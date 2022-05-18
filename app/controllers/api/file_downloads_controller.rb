class Api::FileDownloadsController < Api::SubscriptionActiveController
  include Swagger::Blocks
  load_and_authorize_resource

  respond_to :json

  swagger_path '/api/file_downloads' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'List All Files'
      key :operationId, 'listFiles'
      key :tags, ['fileDownloads']
      response 200 do
        schema do
          key :type, :array
          items do
            key :'$ref', :FileDownloadModel
          end
        end
      end
      response :unauthorized
      response :not_acceptable
    end
  end


  # GET /entities
  # GET /entities.json
  def index
    render json: FileDownload.accessible_by(current_ability).map { |e| e.file_response }, status: :ok
  end

  swagger_path '/api/file_downloads/{id}' do
    operation :get do
      security do
        key :access_token, []
        key :client, []
        key :uid, []
        key :token_type, []
        key :expiry, []
        key :domain_name, []
      end
      key :description, 'Get details of a file download'
      key :operationId, 'getFile'
      key :tags, ['fileDownloads']
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'File Download ID'
        key :required, true
        key :type, :integer
        key :format, :int64
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
  # GET /api/file_downloads/:id
  def show
    render json: FileDownload.find(params[:id]).file_response, status: :ok
  end


end
