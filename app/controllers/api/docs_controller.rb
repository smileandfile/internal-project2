class Api::DocsController < Api::ApiController
  include Swagger::Blocks
  skip_before_action :authenticate_user!
  swagger_root do
    key :swagger, '2.0'
    info do
      key :title, 'GSTN ASP API'
      key :description, 'GSTN DESKTOP API '
     end
    key :basePath, ENV['HOST']
    key :schemes, ['https', 'http']
    key :consumes, ['application/json']
    key :produces, ['application/json']


    security_definition :access_token do
      key :type, :apiKey
      key :name, 'access-token'
      key :in, :header
    end
    security_definition :client do
      key :type, :apiKey
      key :name, 'client'
      key :in, :header
    end
    security_definition :uid do
      key :type, :apiKey
      key :name, 'uid'
      key :in, :header
    end
    security_definition :token_type do
      key :type, :apiKey
      key :name, 'token-type'
      key :in, :header
    end
    security_definition :expiry do
      key :type, :apiKey
      key :name, 'expiry'
      key :in, :header
    end
    security_definition :domain_name do
      key :type, :apiKey
      key :name, 'domain-name'
      key :in, :header
    end
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    Api::RolesController,
    Role,
    ApplicationRecord,
    Api::Users::SessionsController,
    Api::Users::PasswordsController,
    Api::UsersController,
    User,
    Api::EntitiesController,
    Entity,
    Api::DomainsController,
    Domain,
    Api::BranchesController,
    Branch,
    Api::GstinsController,
    Gstin,
    Api::GstnAuthController,
    Api::Gstn1Controller,
    Api::Gstn2aController,
    Api::Gstr1aController,
    Api::Gstr3bController,
    Api::Gstr2Controller,
    Api::GstnBaseController,
    Api::GstnAllController,
    FileDownload,
    Api::FileDownloadsController,
    Api::DscController,
    Api::LedgerController,
    Api::PublicApisController,
    Api::Gstr3Controller,
    Api::Gstr4Controller,
    Api::Gstr6Controller,
    Api::Gstr9Controller,
    Api::Gstr9aController,
    Api::EwaybillsController,
    Api::Gstr9cController,
    self
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end

  def show
    render json: Swagger::Blocks.build_api_json(params[:id], SWAGGERED_CLASSES)
  end
end
