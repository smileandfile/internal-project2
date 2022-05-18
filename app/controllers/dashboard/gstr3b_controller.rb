require "json-schema"
class Dashboard::Gstr3bController < Dashboard::GstnBaseController

  before_action :set_gstin, :set_return_period
  before_action :check_expires_at, except: [:request_otp]
  skip_before_action :authenticate_user!, only: [:save_gstr3b]

  before_action :check_super_admin

  def check_super_admin
    redirect_to dashboard_path unless current_user&.super_admin?
  end

  def index
  end

  def import_excel
  end

  def save_gstr3b_excel
    begin
      excel_importer = Gstr3bExcelImporter.new
      excel_options = { file: params[:file] }
      @excel_response = excel_importer.import(excel_options)
      schema = File.read("app/lib/gstr_schema/SAVE_GSTR3B_schema.json")
      a = JSON::Validator.fully_validate(schema, @payload)
      @errors = []
      if a != true
        @errors = a
      end
      @@gsp_api ||= Gsp::AuthenticatedApi.new()
      user_ip = request.remote_ip
      @@gsp_api.prepare_for_gstin(@gstin, user_ip, current_user)
      request_data = {}
      request_data[:data] = @excel_response[:gstr3b]
      request_data[:return_period] = @return_period
      request_data[:gstin] = @excel_response[:gstin]
      @payload = request_data[:data]
      @payload[:ret_period] = @return_period
      gstr3b = Gsp::Gstr3b.new(@@gsp_api)
      @response = gstr3b.save_gstr3b(request_data)
    rescue Exception => exception
      @message = {msg: exception.message, upstream_headers: exception.upstream_headers}
    end
  end

  def save_gstr3b
    @gstr3b = Gstr3b.new
    begin
      @gstin = current_gstin
      @gstin = params[:gstr3b][:gstin]
      payload = { ret_period: "082017" }
      @payload = payload.merge!(
        convert_all_strings_to_numbers_when_possibset_gstin_urlle(params[:gstr3b].to_hash)
      )
      # TODO REMOVE EMPTY ROWS

      schema = File.read("app/lib/gstr_schema/SAVE_GSTR3B_schema.json")
      a = JSON::Validator.fully_validate(schema, payload)
      @errors = []
      if a != true
        @errors = a
      end
      #save_gstr3b(payload)
    rescue  Exception => e
      puts "Error: #{e}"
      redirect_to new_dashboard_gstr3b_path, notice: e
    end
  end

  def file_gstr3b(payload)
    gstr3b = Gsp::Gstr3b.new(@@gsp_api)
    response = gstr3b.save_gstr3b(payload)
  end

  def new
    auth_header = helpers.current_react_token
    auth_header['gstin-id'] = session[:current_gstin]
    @props = {
       auth_header: auth_header,
       states: STATE_CODES,
       gstin: @gstin.as_json,
       set_gstin_url: set_gstin_dashboard_gstn_base_index_url,
       save_gstr3b_url: save_gstr3b_api_gstr3b_index_url,
       return_period: @return_period
    }
  end

  def track_status
    gstin_id = @gstin.id
    auth_header = helpers.current_react_token
    auth_header['gstin-id'] = gstin_id
    @props = {
       auth_header: auth_header,
       gstin: @gstin.as_json,
       set_gstin_url: set_gstin_dashboard_gstn_base_index_url,
       gstr3b_track_status_url: track_status_api_gstr3b_index_url,
       return_period: @return_period
    }

  end

  def convert_all_strings_to_numbers_when_possible(hash)
    hash.each do |k, v|
      if v.is_a?(String)
        begin
          hash[k] = Float(v)
        rescue
          # do nothing
        end
      elsif v.is_a?(Hash)
        convert_all_strings_to_numbers_when_possible v
      elsif v.is_a?(Array)
        v.flatten.each { |x| convert_all_strings_to_numbers_when_possible(x) if x.is_a?(Hash) }
      end
    end
    hash
  end

  def request_otp
    gstin_id = session[:current_gstin]
    auth_header = helpers.current_react_token
    auth_header['gstin-id'] = gstin_id
    @props = {
       auth_header: auth_header,
       gstin: @gstin.as_json,
       set_gstin_url: set_gstin_dashboard_gstn_base_index_url,
       request_otp_url: request_otp_api_gstn_auth_index_url,
       confirm_otp_url: confirm_otp_api_gstn_auth_index_url,
       gstr3b_index_url: dashboard_gstr3b_index_url
    }
  end

  def details
    gstin_id = @gstin.id
    auth_header = helpers.current_react_token
    auth_header['gstin-id'] = gstin_id
    @props = {
       auth_header: auth_header,
       gstin: @gstin.as_json,
       set_gstin_url: set_gstin_dashboard_gstn_base_index_url,
       gstr3b_details_url: gstr3b_details_api_gstr3b_index_url,
       return_period: @return_period
    }
  end

  def submit
    gstin_id = @gstin.id
    auth_header = helpers.current_react_token
    auth_header['gstin-id'] = gstin_id
    @props = {
       auth_header: auth_header,
       gstin: @gstin.as_json,
       set_gstin_url: set_gstin_dashboard_gstn_base_index_url,
       gstr3b_submit_url: submit_gstr3b_api_gstr3b_index_url,
       return_period: @return_period
    }
  end


  def offset_liability
    gstin_id = @gstin.id
    auth_header = helpers.current_react_token
    auth_header['gstin-id'] = gstin_id
    @props = {
       auth_header: auth_header,
       gstin: @gstin.as_json,
       set_gstin_url: set_gstin_dashboard_gstn_base_index_url,
       gstr3b_offset_url: offset_liability_api_gstr3b_index_url,
       return_period: @return_period
    }
  end

  def check_expires_at
    redirect_to request_otp_dashboard_gstr3b_index_path unless !@gstin.auth_token_expires_at.nil? && @gstin.auth_token_expires_at > Time.now
  end

  private

  def set_gstin
    @gstin = Gstin.find(session[:current_gstin])
  end

  def set_return_period
    @return_period = session[:current_return_period]
  end



end
