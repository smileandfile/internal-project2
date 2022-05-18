require 'exceptions'

class Api::EwaybillsController < Api::SubscriptionActiveController
  include Swagger::Blocks
  respond_to :json

  skip_before_action :authenticate_user!
  skip_before_action :check_roles
  skip_before_action :check_email_verified
  skip_before_action :check_phone_verified
  skip_before_action :check_subcription_active

  # before_action :check_valid_user, except: [:authenticate]
  before_action :check_gstin_in_headers

  before_action :create_sub_eway

  def initialize
    @eway_api = Gsp::EwayBillAuthenticatedApi.new
  end


  swagger_schema :BaseGstinModel do
    key :required, [:gstin]
    property :gstins  do
      key :type, :string
      key :message, "Ex. 33GSPTN2931G1ZB"
    end
  end

  swagger_schema :EwayBillDataModel do
    allOf do
      schema do
        key :required, [:eway_bill]
        property :eway_bill do
          key :type, :object
        end
      end
    end
  end

  swagger_schema :EwayBillNumberModel do
    key :required, [:bill_number]
    property :bill_number  do
      key :type, :string
      key :message, 'Eway Bill Number'
    end
  end

  swagger_schema :EwayBillGstinModel do
    key :required, [:gstin_number]
    property :gstin_number  do
      key :type, :string
      key :required, true
      key :message, 'Enter gstin number you want to search'
    end
  end

  swagger_schema :PublicApiAuthenticateModel do
    key :required, %i[token est]
    property :username do
      key :type, :string
      key :message, 'username'
    end
    property :password do
      key :type, :string
      key :message, 'password'
    end
    property :clientid do
      key :type, :string
      key :message, 'client id'
    end
    property :'client-secret' do
      key :type, :string
      key :message, 'client secret'
    end
  end

  swagger_path '/api/ewaybills/authenticate' do
    operation :post do
      key :description, 'authenticate with eway bill api'
      key :operationId, 'getewaybillAuth'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :username
        key :in, :header
        key :description, 'eway bill username'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :password
        key :in, :header
        key :description, 'eway bill password'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'gstin'
        key :in, :header
        key :description, 'Enter your gstin number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client Id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      response 200 do
        schema do
          key :'$ref', :PublicApiAuthenticateModel
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def authenticate 
    username = request.headers['username']
    password = request.headers['password']
    common_response = {}
    auth_token = ""
    if username.nil? || password.nil?
      return render json: {message: "Please provide eway bill username and password"}, status: :ok 
    end
    is_token_expired = false
    if @sub_eway_user&.auth_token_expires_at.present?
      is_token_expired = @sub_eway_user&.auth_token_expires_at.to_time <= Time.now
    end
    if @sub_eway_user&.auth_token == "" || @sub_eway_user&.auth_token.nil? || is_token_expired
      @eway_api.gstin = @gstin
      @eway_api.environment = @sub_eway_user.ewaybill.eway_environment.to_sym
      @eway_api.endpoint = @sub_eway_user.ewaybill.endpoint_name.present? ? @sub_eway_user.ewaybill.endpoint_name.constantize : nil
  
      auth_response = @eway_api.get_auth_token(username, password)
      if auth_response['status'] == "1"
        auth_token = auth_response['authtoken']
      else 
        return render json: JSON.parse(auth_response), status: :internal_server_error 
      end
    else
      auth_token = @sub_eway_user.auth_token  
    end
    common_response = {
      auth_token: auth_token,
      auth_token_expires_at: @sub_eway_user.auth_token_expires_at
    }
    @eway_user = @sub_eway_user&.ewaybill
    @eway_user.token_request_count = (@eway_user.token_request_count.nil? ? 0 : @eway_user.token_request_count) + 1
    @eway_user.save!
    
    return render json: common_response, status: :ok 
  end

  swagger_path '/api/ewaybills/eway_bill' do
    operation :get do
      key :operationId, 'getEwayBill'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :bill_number
        key :in, :query
        key :type, :string
        key :required, true
        schema do
          key :'$ref', :EwayBillNumberModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def eway_bill
    gstin = params[:gstin]
    eway_bill_number = params[:bill_number]
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    data = {
      gstin: @gstin,
      bill_number: eway_bill_number
    }
    eway_response = eway.retrieve_bill(data)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/eway_bill_transporter' do
    operation :get do
      key :operationId, 'getEwayBillTrasporter'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :date
        key :in, :query
        key :type, :string
        key :required, true
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def eway_bill_transporter
    data = {
      date: params[:date],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.eway_bils_transporter(data)
    return render json: eway_response, status: :ok
  end


  swagger_path '/api/ewaybills/eway_bils_transporter_by_gstin' do
    operation :get do
      key :operationId, 'getEwayBillGstin'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :date
        key :in, :query
        key :type, :string
        key :required, true
      end
      parameter do
        key :name, :gen_gstin
        key :in, :query
        key :type, :string
        key :required, true
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def eway_bils_transporter_by_gstin
    data = {
      date: params[:date],
      gstin: @gstin,
      gen_gstin: params[:gen_gstin]
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.eway_bils_transporter_by_gstin(data)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/eway_bils_generated_by_others' do
    operation :get do
      key :operationId, 'getEwayBillGenByOthers'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :date
        key :in, :query
        key :type, :string
        key :required, true
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def eway_bils_generated_by_others
    data = {
      date: params[:date],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.eway_bils_generated_by_others(data)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/cons_eway_bills' do
    operation :get do
      key :operationId, 'getEwayBillGenByOthers'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :trip_sheet_number
        key :in, :query
        key :type, :string
        key :required, true
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def cons_eway_bills
    data = {
      trip_sheet_number: params[:trip_sheet_number],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.cons_eway_bills(data)
    return render json: eway_response, status: :ok
  end


  swagger_path '/api/ewaybills/generate_eway_bill' do
    operation :post do
      key :operationId, 'generateEwayBills'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :eway_bill
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :EwayBillDataModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def generate_eway_bill
    check_auth_token(@sub_eway_user)
    body = {
      data: params[:eway_bill],
      gstin: @gstin
    }
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.generate_eway_bill(body)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/update_vehicle_number' do
    operation :post do
      key :operationId, 'updateVehicleNumber'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :eway_bill
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :EwayBillDataModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def update_vehicle_number
    body = {
      data: params[:eway_bill],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.update_vehicle_number(body)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/cancel_eway_bill' do
    operation :post do
      key :operationId, 'cancelEwayBill'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :eway_bill
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :EwayBillDataModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def cancel_eway_bill
    body = {
      data: params[:eway_bill],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.cancel_eway_bill(body)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/reject_eway_bill' do
    operation :post do
      key :operationId, 'rejectEwayBill'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :eway_bill
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :EwayBillDataModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def reject_eway_bill
    body = {
      data: params[:eway_bill],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.reject_eway_bill(body)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/generate_consolidated_eway_bill' do
    operation :post do
      key :operationId, 'generateConsolidatedEwayBill'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :eway_bill
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :EwayBillDataModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def generate_consolidated_eway_bill
    data = {
      data: params[:eway_bill],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.generate_consolidated_eway_bill(data)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/update_transporter' do
    operation :post do
      key :operationId, 'updateTransporter'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :eway_bill
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :EwayBillDataModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def update_transporter
    data = {
      data: params[:eway_bill],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.update_transporter(data)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/extend_validity' do
    operation :post do
      key :operationId, 'extendValidity'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :eway_bill
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :EwayBillDataModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def extend_validity
    data = {
      data: params[:eway_bill],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.extend_validity(data)
    return render json: eway_response, status: :ok
  end
  swagger_path '/api/ewaybills/regenerate_consolidated_eway_bill' do
    operation :post do
      key :operationId, 'extendValidity'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :eway_bill
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :EwayBillDataModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def regenerate_consolidated_eway_bill
    data = {
      data: params[:eway_bill],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.regenerate_consolidated_eway_bill(data)
    return render json: eway_response, status: :ok
  end


  swagger_path '/api/ewaybills/gstin_detail' do
    operation :get do
      key :operationId, 'getGstinDetails'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin_number
        key :in, :query
        key :type, :string
        key :required, true
        schema do
          key :'$ref', :EwayBillGstinModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def gstin_detail
    gstin = params[:gstin]
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    data = {
      gstin: @gstin,
      gstin_number: params[:gstin_number]
    }
    eway_response = eway.gstin_detail(data)
    return render json: eway_response, status: :ok
  end
  
  swagger_path '/api/ewaybills/transporter_detail' do
    operation :get do
      key :operationId, 'getGstinDetails'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :trn_no
        key :in, :query
        key :type, :string
        key :description, "Transporter GSTIN  or Transin for which the details are required"
        key :required, true
        schema do
          key :'$ref', :EwayBillGstinModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def transporter_detail
    gstin = params[:gstin]
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    data = {
      gstin: @gstin,
      trn_no: params[:trn_no]
    }
    eway_response = eway.transporter_detail(data)
    return render json: eway_response, status: :ok
  end
  swagger_path '/api/ewaybills/hsn_code_detail' do
    operation :get do
      key :operationId, 'getGstinDetails'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :hsn_code
        key :in, :query
        key :type, :string
        key :description, "
        hsncode for which the details are required"
         key :required, true
        schema do
          key :'$ref', :EwayBillGstinModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def hsn_code_detail
    gstin = params[:gstin]
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    data = {
      gstin: @gstin,
      hsn_code: params[:hsn_code]
    }
    eway_response = eway.hsn_code_detail(data)
    return render json: eway_response, status: :ok
  end
  
  swagger_path '/api/ewaybills/error_list' do
    operation :get do
      key :operationId, 'getGstinDetails'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def error_list
    gstin = params[:gstin]
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    data = {
      gstin: @gstin
    }
    eway_response = eway.error_list(data)
    return render json: eway_response, status: :ok
  end


  swagger_path '/api/ewaybills/multi_vehicle_movement_initiation' do
    operation :post do
      key :operationId, 'multiVehicleMovementInitiation'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :eway_bill
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :EwayBillDataModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def multi_vehicle_movement_initiation
    data = {
      data: params[:eway_bill],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.multi_vehicle_movement_initiation(data)
    return render json: eway_response, status: :ok

  end

  swagger_path '/api/ewaybills/multi_vehicle_add' do
    operation :post do
      key :operationId, 'multiVehicleMovementInitiation'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :eway_bill
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :EwayBillDataModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def multi_vehicle_add
    data = {
      data: params[:eway_bill],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.multi_vehicle_add(data)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/multi_vehicle_update' do
    operation :post do
      key :operationId, 'multiVehicleMovementInitiation'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :eway_bill
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :EwayBillDataModel
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def multi_vehicle_update
    data = {
      data: params[:eway_bill],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.multi_vehicle_update(data)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/eway_bill_generated_by_consigner' do
    operation :get do
      key :operationId, 'getEwayBillGeneratedByConsignor'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'Enter your GSTIN number'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :docType
        key :in, :query
        key :description, 'Enter Document Type'
        key :type, :string
        key :required, true
      end
      parameter do
        key :name, :docNo
        key :in, :query
        key :description, 'Enter Documnent Number'
        key :type, :string
        key :required, true
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def eway_bill_generated_by_consigner
    data = {
      docType: params[:docType],
      docNo: params[:docNo],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.bill_generated_by_consigner(data)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/eway_bill_for_transporter_by_state' do
    operation :get do
      key :operationId, 'getEwayBillGeneratedByConsignor'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'GSTIN of Requester(Transporter)'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :date
        key :in, :query
        key :description, 'Enter Generated Date'
        key :type, :string
        key :required, true
      end
      parameter do
        key :name, :state_code
        key :in, :query
        key :description, 'Enter state code of the generator'
        key :type, :string
        key :required, true
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def eway_bill_for_transporter_by_state
    data = {
      date: params[:date],
      state_code: params[:state_code],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.eway_bill_for_transporter_by_state(data)
    return render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/ewaybill_by_date' do
    operation :get do
      key :operationId, 'getEwayBillGeneratedByConsignor'
      key :description, 'This API provides the list e-way bill details for a generated date.'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'GSTIN of Requester(Tax payer or Transporter)'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :date
        key :in, :query
        key :description, 'Enter Generated Date'
        key :type, :string
        key :required, true
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def ewaybill_by_date
    data = {
      date: params[:date],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.ewaybill_by_date(data)

    render json: eway_response, status: :ok
  end

  swagger_path '/api/ewaybills/ewaybill_rejected_by_others' do
    operation :get do
      key :operationId, 'getEwayBillGeneratedByConsignor'
      key :description, 'This API provides the list e-way bills rejected by other party by date.'
      key :tags, ['ewayBillAPI']
      parameter do
        key :name, :clientid
        key :in, :header
        key :description, 'Enter your client id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'client-secret'
        key :in, :header
        key :description, 'Enter your client secret'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstin
        key :in, :header
        key :description, 'GSTIN of Requester(Tax payer or Transporter)'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :date
        key :in, :query
        key :description, 'Enter Date'
        key :type, :string
        key :required, true
      end
      response :unauthorized
      response :not_acceptable
    end
  end

  def ewaybill_rejected_by_others
    data = {
      date: params[:date],
      gstin: @gstin
    }
    check_auth_token(@sub_eway_user)
    @eway_api.update_eway_user_info(@sub_eway_user)
    @eway_api.gstin = @gstin
    eway = Gsp::EwayBill.new(@eway_api)
    eway_response = eway.ewaybill_rejected_by_others(data)

    render json: eway_response, status: :ok
  end


  private

  def create_sub_eway
    client_id = request.headers['clientid']
    client_secret = request.headers['client-secret']
    gstin = request.headers['gstin']
    @parent_eway_user = ''
    @sub_eway_user = ''
    if client_id.nil? || client_secret.nil?
      raise NotValidEwayBillUserException.new
    else 
      @eway_user = Ewaybill.where(client_id: client_id, client_secret: client_secret).first
      if @eway_user.nil? || @eway_user.is_active.to_sym == :no
        raise NotValidEwayBillUserException.new
      end
      sub_eway_present = @eway_user.eway_bill_multiple_auths.find_by(gstin: gstin)
      if sub_eway_present.nil?
        @sub_eway_user = @eway_user.eway_bill_multiple_auths.build({})
        @sub_eway_user.gstin = gstin
        @sub_eway_user.save
      else
        @sub_eway_user = sub_eway_present
      end
    end
    @eway_api.eway_bill_model = @sub_eway_user
    return @sub_eway_user

  end

  def check_gstin_in_headers
    @gstin = request.headers['gstin']
    raise EwayBillGstinNilException.new if @gstin.nil?
    return @gstin
  end

  def check_auth_token(eway_user)
    is_token_expired = false
    if eway_user&.auth_token_expires_at.present?
      is_token_expired = eway_user&.auth_token_expires_at.to_time <= Time.now
    end
    if eway_user.present? && (eway_user&.auth_token == "" || eway_user&.auth_token.nil? ||  is_token_expired)
      raise AuthTokenExpiredException.new
    end
  end

end
