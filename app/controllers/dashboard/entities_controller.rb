class Dashboard::EntitiesController < Dashboard::DashboardController
  before_action :set_entity, only: [:show, :update, :destroy, :edit]
  load_and_authorize_resource except: [:create, :new]

  # GET /entities
  # GET /entities.json
  def index
    @entities = Entity.accessible_by(current_ability)
  end

  # GET /entities/1
  # GET /entities/1.json
  def show
  end

  def new
    @entity = Entity.new
    @domains = Domain.accessible_by(current_ability)
  end

  # POST /entities
  # POST /entities.json
  def create
    raise CanCan::AccessDenied.new("Not authorized!", :manage, Entity) \
        unless can_user_update_to_domain

    @entity = Entity.new(entity_params)
    respond_to do |format|
      if @entity.save
        format.html { redirect_to dashboard_entity_path(@entity), notice: 'Entity was successfully created.' }
        format.js { render 'shared/simple_success_modal', locals: { type: 'ENTITY CREATED', message: ''} }
        format.json { render :show, status: :created, location: @entity }
      else
        format.html { render :new }
        @model = @entity
        format.json { render json: @model, status: :unprocessable_entity }
        format.js   { render 'shared/simple_success_modal' }
      end
    end
  end
  # PATCH/PUT /entities/1
  # PATCH/PUT /entities/1.json
  def update
    raise CanCan::AccessDenied.new("Not authorized!", :manage, Entity) \
        unless can_user_update_to_domain

    respond_to do |format|
      if @entity.update(entity_params)
        format.html { redirect_to dashboard_entity_path(@entity), notice: 'Entity was successfully updated.' }
        format.js { render 'shared/simple_success_modal', locals: { type: 'ENTITY UPDATED', message: ''} }
        format.json { render :show, status: :created, location: @entity }
      else
        format.html { render :new }
        @model = @entity
        format.json { render json: @model, status: :unprocessable_entity }
        format.js   { render 'shared/simple_success_modal' }
      end
    end
  end
  
  def gstins
    @gstins = @entity.gstins
    respond_to do |format|
      format.js { render :gstins, locals: { gstins: @gstins, entity: @entity} }
    end
  end


  # DELETE /entities/1
  # DELETE /entities/1.json
  def destroy
    name = @entity.company_name
    @entity.destroy
    respond_to do |format|
      format.html { redirect_to dashboard_entities_path, notice: "Successfully deleted the entity #{name}" }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity
      @entity = Entity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_params
      params.require(:entity).permit(:company_name, :domain_id, :address, :pan_number)
    end

    def can_user_update_to_domain
      return true unless entity_params[:domain_id].present?
      domain = Domain.find(entity_params[:domain_id])
      return false unless domain.present?
      current_user.check_domain(domain.name)
    end
end
