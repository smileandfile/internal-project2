class Dashboard::RolesController < Dashboard::DashboardController

  before_action :set_role, except: [:index, :new, :create]
  load_and_authorize_resource except: [:create, :new]


  def index
    @roles = Role.all
  end

  def show
  end

  def new
    @role = Role.new
  end

  def edit
  end

  def create
    @role = Role.create(role_secure_params)
    respond_to do |format|
      if @role.save
        format.html { redirect_to dashboard_roles_path, notice: "Updated subccessfully."}
      else
        format.html { render :new}
        format.json { render json: @role, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @role.update(role_secure_params)
        format.html { redirect_to dashboard_path, notice: "Updated subccessfully."}
      else
        format.html { render :edit}
        format.json { render json: @role, status: :unprocessable_entity }
      end
    end

  end

  def show
  end

  def edit
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_secure_params
    params.require(:role).permit(:name, :parent_id, allowed_actions: [])
  end

end