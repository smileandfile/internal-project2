require 'digest'

class Api::GstnAllController < Api::GstnBaseController
  include SelectHashValues
  include Swagger::Blocks
  before_action :get_return_period, only: [:view_track_return_status]
  respond_to :json
  # load_and_authorize_resource only: [:file, :all_files]

  skip_before_action :set_gstin, :gsp_api, only: [:file]

  swagger_path '/api/gstn_all/load_files' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Get server to load files for given Token and Est'
      key :operationId, 'loadFiles'
      key :tags, ['fileDownloads']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :data
        key :in, :body
        key :type, :string
        schema do
          allOf do
            schema do
              key :'$ref', :FileDownloadModel
            end
            schema do
              key :'$ref', :BaseReturnPeriodModel
            end
          end
        end
      end
      response 200 do
        schema do
          key :'$ref', :FileDownloadModel
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def load_files
    response = FileDownload.create!(
      est: params[:est].to_i,
      user: current_user,
      gstin: @gstin,
      token: params[:token],
      return_period: params[:return_period],
      user_ip: request.remote_ip
    )

    render json: response, status: :ok
  end

  swagger_schema :BaseReturnModelWithFileType do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        property :type do
          key :type, :string
          key :message, 'Return Type Ex. R1'
        end
      end
    end
  end

  swagger_path '/api/gstn_all/view_track_return_status' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is to view and track Returns status'
      key :operationId, 'viewTrackReturnStatus'
      key :tags, ['viewTrackReturnStatus']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :gstn_all
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :BaseReturnModelWithFileType
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseReturnModelWithFileType
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def view_track_return_status
    gstn_all = Gsp::All.new(@@gsp_api)
    @data = @data.merge(select_hash_values(params,
                                           [:return_period, :type]
                                          ))
    response = gstn_all.view_track_return_status(@data)
    render json: response, status: :ok
  end

  swagger_path '/api/gstn_all/download_doc' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Document details'
      key :operationId, 'viewTrackReturnStatus'
      key :tags, ['viewTrackReturnStatus']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :'doc-id'
        key :in, :header
        key :description, 'Document ID'
        key :required, true
        key :type, :string
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseReturnModelWithFileType
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def download_doc
    gstn_all = Gsp::All.new(@@gsp_api)
    data = {
      doc_id: request.headers['doc-id']
    }
    response = gstn_all.download_doc(data)

    render json: response, status: :ok
  end

  swagger_path '/api/gstn_all/upload_doc' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Uploading Document'
      key :operationId, 'viewTrackReturnStatus'
      key :tags, ['viewTrackReturnStatus']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :upload_doc_content
        key :in, :body
        key :type, :string
        schema do
          key :'$ref', :UploadDocBase
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseReturnModelWithFileType
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end  

  def upload_doc
    gstn_all = Gsp::All.new(@@gsp_api)
    data = select_hash_values(params, [:ct, :doc, :ty, :doc_nam])
    response = gstn_all.upload_doc(data)

    render json: response, status: :ok
  end

  swagger_path '/api/gstn_all/late_fee' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is to get the details of late fee levied in GSTR3B and GSTR4'
      key :operationId, 'viewTrackReturnStatus'
      key :tags, ['viewTrackReturnStatus']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :ret_period
        key :in, :query
        key :description, 'Return Period'
        key :required, true
        key :type, :string
      end
      parameter do 
        key :name, :rtn_type
        key :in, :query
        key :description, 'Return Type'
        key :required, true
        key :type, :string
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseReturnModelWithFileType
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def late_fee
    gstn_all = Gsp::All.new(@@gsp_api)
    data = select_hash_values(params, [:ret_period, :rtn_type])
    response = gstn_all.late_fee(data)

    render json: response, status: :ok
  end

  swagger_path '/api/gstn_all/doc_status' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is to get the details of late fee levied in GSTR3B and GSTR4'
      key :operationId, 'viewTrackReturnStatus'
      key :tags, ['viewTrackReturnStatus']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do 
        key :name, :doc_id
        key :in, :query
        key :description, 'Document ID'
        key :required, true
        key :type, :string
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseReturnModelWithFileType
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def doc_status
    gstn_all = Gsp::All.new(@@gsp_api)
    data = select_hash_values(params, [:doc_id])
    response = gstn_all.doc_status(data)

    render json: response, status: :ok
  end

  swagger_path '/api/gstn_all/proceed_to_file' do
    operation :post do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'This API is for proceeding to file GSTR data'
      key :operationId, 'viewTrackReturnStatus'
      key :tags, ['viewTrackReturnStatus']
      parameter do
        key :name, :'gstin-id'
        key :in, :header
        key :description, 'gstin-id'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :data
        key :in, :body
        key :type, :string
        schema do
          allOf do
            schema do
              key :'$ref', :BaseSingleGstinModel
            end
            schema do
              key :'$ref', :BaseReturnPeriodModel
            end
          end
        end
      end
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :BaseReturnModelWithFileType
          end
        end
      end
      response :unauthorized
      response :not_acceptable
      response :requested_range_not_satisfiable
    end
  end

  def proceed_to_file
    gstn_all = Gsp::All.new(@@gsp_api)
    data = select_hash_values(params, [:gstin, :return_period], {return_period: :ret_period})
    response = gstn_all.proceed_to_file(data)

    render json: response, status: :ok
  end

end
