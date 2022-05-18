require 'exceptions'
require 'zlib' 
require 'open-uri'
require 'rubygems/package'
require "httparty"
# == Schema Information
#
# Table name: file_downloads
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  gstin_id               :integer
#  est                    :integer
#  ek                     :string
#  token                  :string
#  file_count             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_ip                :string
#  return_period          :string
#  log                    :json
#  file_eta               :datetime
#  waiting_message        :string
#  file_download_gstin_id :integer
#

MAX_TRIES = 1

class FileDownload < ApplicationRecord
  include SelectHashValues

  belongs_to :user
  belongs_to :gstin
  belongs_to :file_download_gstin
  has_many :individual_files, dependent: :destroy

  after_create :set_file_download_eta, :set_gstin
  after_create :wait_to_download

  validates :est, presence: true, numericality: true
  validates :user, presence: true
  validates :gstin, presence: true
  validates :token, presence: true

  swagger_schema :FileDownloadModel do
    key :required, %i[token est]
    property :token do
      key :type, :string
      key :message, 'File download token as received from GSTN'
    end
    property :est do
      key :type, :integer
      key :message, 'Estimated time in which file will be available'
    end
  end

  def set_file_download_eta
    self.file_eta ||= est.minutes.from_now(Time.now) + 5.minutes # 5 mminutes extra for downloading and trying
    self.waiting_message ||= "please come after #{(self.file_eta - Time.now).to_i/ 60} minutes"
  end

  def set_gstin
    old_gstin = gstin.as_json
    old_gstin.delete("id")
    f= FileDownloadGstin.new(old_gstin)
    f.save
    self.file_download_gstin = f
    self.save
  end

  def wait_to_download
    self.delay(run_at: est.minutes.from_now(Time.now)).download_files
  end

  def get_file_info_from_gstn
    time = Time.now

    gsp_api ||= Gsp::AuthenticatedApi.new()
    gsp_api.prepare_for_gstin(file_download_gstin, user_ip || '127.0.0.1', user) 

    self.log ||= {}
    log['requests'] ||= []
    log['responses'] ||= []

    log['requests'] << {
      time: time
    }

    gsp_all_api = Gsp::All.new(gsp_api)
    begin
      response = gsp_all_api.file_details({
                    token: token,
                    ret_period: return_period,
                    gstin: gstin.gstin_number
                  })
    rescue ::GstnUpstreamException => exception
      log['responses'] << {
        message: exception.message,
        time: time
      }
      self.waiting_message = exception.message
      save
      raise exception
    else
      log['responses'] << {
        message: 'OK',
        time: time
      }
    end
    response
  end

  def download_files
    response = JSON.parse(get_file_info_from_gstn)
    puts "Getting response #{response}"
    self.file_count = response['fc'].to_i
    self.ek = response['ek']
    self.gst_response = response
    response['urls'].each do |url_object|
      puts "response data #{url_object}"
      file = IndividualFile.new(invoice_count: url_object['ic'].to_i,
                                filename: url_object['ul'].split('?').first,
                                hash_value: url_object['hash'],
                                file_download: self)
      if file_download_gstin.gsp_environment.to_sym == :production
        base_url = "https://g2bfiles.gstone.in"
      else
        base_url = 'http://sbfiles.gstone.in'
      end                          
      tar_url = base_url + url_object['ul']  
      file.remote_encrypted_file_url = tar_url
      file.save(validate: false) 
    end
    self.delay.make_large_file

    save
  end

  def make_large_file
    base_key = ""
    big_array = {
      "#{base_key}": []
    }
    individual_files.each_with_index do |file, index|
      if file.filename != "LargeFile"
        url = file.decrypted_file_url
        response = HTTParty.get(url)
        final_response = response.parsed_response
        if index == 0
          base_key =  final_response.first.keys[0]
          big_array = {
            "#{base_key}": []
          }
        end
        big_array[base_key.to_sym].push(final_response[0][base_key][0])
      end
    end

    IndividualFile.skip_callback(:create, :after, :save_extract_and_decrypt_tar)
    ind_f = IndividualFile.new
    ind_f.file_download = self
    ind_f.filename = "LargeFile"
    new_file_name = SecureRandom.hex(3) + self.id.to_s + '.json'
    new_file_path = Rails.root.join('tmp/uploads' + new_file_name)
    File.open(new_file_path, 'w') {|f| f.write(big_array.to_json) }
    ind_f.decrypted_file = new_file_path.open
    ind_f.save!(validate: false)
    File.delete(new_file_path) # delete json file after saving to azure
    IndividualFile.set_callback(:create, :after, :save_extract_and_decrypt_tar)

  end

  def extract_pairs(file1, file2)
    h2 = file2.each_with_object({}) { |g,h| h.update(g[:name]=>g) }
    file1.each_with_object([]) do |g,a|
      k = g[:name]
      a << [g,h2[k]] if h2.key?(k)
    end
  end
  

  def file_response(count = 0)
    begin
      files = []
      individual_files.each do |file|
        data = { filename: file.filename}
        files.push(data.merge(decrypted_file_url: file.decrypted_file_url)) unless file.decrypted_file_url.nil? 
      end
      file_eta_minutes = file_eta > Time.now ? "#{(file_eta  - Time.now).to_i/ 60}" : 0
      waiting_message = file_eta > Time.now ? "please come after #{file_eta_minutes} minute" : "Your file is ready to download"
      if file_eta > Time.now && files.length > 0
        waiting_message = "Your file is ready to download"
      elsif Time.now > file_eta && files.length == 0 
        if count < MAX_TRIES
          count = count + 1
          download_files
          file_response(count)
        end
      else  
        waiting_message = "please come after #{file_eta_minutes} minute"
      end
      self.as_json.merge!({files: files, waiting_message: waiting_message, file_eta_minutes: "#{file_eta_minutes}".to_i})
    rescue => exception
      return {message: exception.message}
    end
  end
end
