# == Schema Information
#
# Table name: individual_files
#
#  id               :integer          not null, primary key
#  decrypted_file   :string
#  state            :integer
#  file_download_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  encrypted_file   :string
#  invoice_count    :integer
#  hash_value       :string
#  filename         :string
#

class IndividualFile < ApplicationRecord
  belongs_to :file_download
  enum state: [:scheduled, :downloaded, :decrypted]
  attr_accessor :remote_encrypted_file_url

  mount_uploader :encrypted_file, FileUploader
  mount_uploader :decrypted_file, FileUploader

  after_initialize :set_default_state, if: :new_record?
  # validates :state, presence: true

  after_create :save_extract_and_decrypt_tar


  def save_extract_and_decrypt_tar
    self.delay.extract_and_decrypt_tar(self)
  end

  def extract_and_decrypt_tar(individual_file)
    crypto = GstnCrypto.new
    invoices = []
    original_filename = filename.split('/').last
    url = encrypted_file_url
    
    ek_bytes = Base64.strict_decode64(individual_file.file_download.ek)
    file = PullTempfile.pull_tempfile(url: url, original_filename: original_filename)

    # puts "file.....tar #{original_filename} , #{url}"
    
    tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(file.to_path))
    tar_extract.rewind # The extract has to be rewinded after every iteration
    tar_extract.each do |entry|
      data = entry.read
      # puts "..........encrypted data #{data}"
      unless data.nil?
        encrypted_data = crypto.decrypt_data_without_encode(data.delete('\"'), ek_bytes)
        data = Base64.strict_decode64(encrypted_data)
        # puts "..........decrypted data #{data}"
        invoices.push(JSON.parse(data))
      end
    end
    file.unlink # delete file after you done
    tar_extract.close
    new_file_name = filename.split('/').last
    last_index = new_file_name.rindex('.')
    new_file_name = hash.to_s + new_file_name[0..last_index-5] + '.json'
    new_file_path = Rails.root.join('tmp/uploads' + new_file_name)
    File.open(new_file_path, 'w') {|f| f.write(invoices.to_json) }
    individual_file.decrypted_file = new_file_path.open
    individual_file.save!(validate: false)
    File.delete(new_file_path) # delete json file after saving to azure
  end


  def set_default_state
    self.state ||= :scheduled
  end

  def to_builder
    Jbuilder.new do |json|
      json.(self, :state, :filename)
    end
  end
end
