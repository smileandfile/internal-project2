class Api::Gstr3Controller < Api::GstnBaseController
  include Swagger::Blocks
  include SelectHashValues
  before_action :get_return_period
  respond_to :json

  swagger_schema :BaseFinalModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        property :final do
          key :type, :string
        end
      end
    end
  end
  
  swagger_path '/api/gstr3/gstr3_details' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, "API call for getting all GSTR3 details. The value of the final should be 'N' when fetching data for view(before save/submit) . When fetching data for filing the value has to be 'Y' , else filing will fail."
      key :operationId, 'GetGSTR3Details'
      key :tags, ['gstr3']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr3
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BaseFinalModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseFinalModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def gstr3_details
    gstr3 = Gsp::Gstr3.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params,
                                           [:final]
                                          ))
    response = gstr3.gstr3_details(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr3/generate_gstr3' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, "API call for generate GSTR3 details"
      key :operationId, 'GenerateGstr3'
      key :tags, ['gstr3']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr3
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BaseReturnPeriodModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseReturnPeriodModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def generate_gstr3
    gstr3 = Gsp::Gstr3.new(@@gsp_api)
    response = gstr3.generate_gstr3(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr3/save_gstr3' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for saving all GSTR3 details'
      key :operationId, 'SaveGstr3'
      key :tags, ['gstr3']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr3
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :GstrDataModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :GstrDataModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def save_gstr3
    gstr3 = Gsp::Gstr3.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr3.save_gstr3(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/file_gstr3_esign' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'File GSTR3 with ESIGNing. Please perform AADHAAR OTP request before hitting this API.'
      key :operationId, 'postGSTR3'
      key :tags, ['gstr3']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :body
        key :in, :body
        key :type, :string
        schema do
          allOf do
            schema do
              key :'$ref', :AadhaarEsignRequest
            end
            schema do
              key :'$ref', :GstrDataModel
            end 
          end
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :GstrDataModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def file_gstr3_esign
    gstr3 = Gsp::Gstr3.new(@@gsp_api)
    payload = {
      "aadhaar_number": params[:aadhaar_number],
      "aadhaar_otp": params[:aadhaar_otp],
      "patron_id": params[:patron_id],
      "return_period": params[:return_period],
      "data": params[:data]
    };
    signzy_response = signzy_esign_data(payload)
    payload[:pkcs7_data] = signzy_response['result']['Pkcs7Response']
    payload[:sid] = params[:aadhaar_number]
    payload[:st] = 'ESIGN'
    response = gstr1.file_gstr1(payload)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn1/file_gstr3_dsc' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'File GSTR3 with DSC. Please perform signing of data before hitting this API.'
      key :operationId, 'postGSTR3'
      key :tags, ['gstr3']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :body
        key :in, :body
        key :type, :string
        schema do
          allOf do
            schema do
              key :'$ref', :DscRequest
            end
            schema do
              key :'$ref', :GstrDataModel
            end
          end
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :GstrDataModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def file_gstr3_dsc
    gstr3 = Gsp::Gstr3.new(@@gsp_api)
    secure_params = params.permit(:return_period, :pan_number, :signed_data, data: {})
    payload = {
      "sid": secure_params[:pan_number],
      "return_period": secure_params[:return_period],
      "data": secure_params[:data],
      "pkcs7_data": secure_params[:signed_data],
      "st": "DSC"
    }
    response = gstr3.file_gstr1(payload)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr3/submit_liabilities_and_interest' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for accepting the liabilities and interest from GSTR3'
      key :operationId, 'SubmitLiabilitiesAndInterest'
      key :tags, ['gstr3']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr3
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :GstrDataModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :GstrDataModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def submit_liabilities_and_interest
    gstr3 = Gsp::Gstr3.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr3.submit_liabilities_and_interest(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr3/setoff_liability' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for offsetting the liabilities and interest from GSTR3'
      key :operationId, 'SetoffLiability'
      key :tags, ['gstr3']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr3
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :GstrDataModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :GstrDataModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def setoff_liability
    gstr3 = Gsp::Gstr3.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr3.setoff_liability(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr3/submit_refund' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'API call for submitting the refund claim GSTR3'
      key :operationId, 'SubmitRefund'
      key :tags, ['gstr3']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr3
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :GstrDataModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :GstrDataModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def submit_refund
    gstr3 = Gsp::Gstr3.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params, [:data]))
    response = gstr3.submit_refund(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstr3/return_status' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'GET return status'
      key :operationId, 'GetReturnStatus'
      key :tags, ['commonGSTAPI']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstr3
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :ReturnStatusModel
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :ReturnStatusModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def return_status
    gstr3 = Gsp::Gstr3.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params,
                                           [:reference_id],
                                           {reference_id: :ref_id}
                                          ))
    response = gstr3.return_status(@data)
    render json: response, status: :ok
  end

  protected
  def self.gstin_id_header_required?
    true
  end

end