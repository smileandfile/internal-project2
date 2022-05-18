class Dashboard::UsersController < Dashboard::DashboardController
  before_action :set_user, except: %i[new create permissions index destroy]
  before_action :set_domain
  load_and_authorize_resource except: %i[new create]

  def index
    @users = User.accessible_by(current_ability).where(domain: @domain)
    @roles = Role.where.not(parent_id: nil)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    new_hash = user_params.to_h
    new_hash[:password] = generate_password
    @user = User.new(new_hash)
    @user.role = :user
    @user.domain = @domain
    respond_to do |format|
      if @user.save
        @user.send_reset_password_instructions
        format.html { redirect_to dashboard_domain_users_path(@domain), notice: 'User was successfully created.' }
        format.js { render 'shared/simple_success_modal', locals: { type: 'User Created',
                                                                    message: 'Email will be sent to the user.' \
                                                                             ' The user needs to activate by clicking the url' \
                                                                             ' given in the email. On activation the user can create the password.'}}
        format.json { render :show, status: :created, location: @user }
      else   
        format.html { render :new }
        @model = @user
        format.json { render json: @model, status: :unprocessable_entity }
        format.js   { render 'shared/simple_success_modal' }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to dashboard_domain_users_path(@domain), notice: 'User was successfully updated.' }
        format.js { render 'shared/simple_success_modal', locals: { type: 'User Updated',
                                                                    message: ''}}
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        @model = @user
        format.json { render json: @model, status: :unprocessable_entity }
        format.js   { render 'shared/simple_success_modal' }
      end
    end
  end

  def permissions
    @props = {
      users: @domain.domain_users.map { |u| u.to_builder(permission_ids_only: true).attributes! },
      gstins_by_entities: @domain.gstins.to_a.group_by(&:entity_id),
      entities: @domain.entities,
      roles: Role.all.to_a.group_by(&:parent_id),
      auth_header: helpers.current_react_token
    }
  end

  def destroy
    name = @user.name
    respond_to do |format|
      begin
        @user.destroy
        format.html { redirect_to dashboard_domain_users_path(@domain), notice: "Successfully deleted the user #{name}" }
      rescue
        format.html { redirect_to dashboard_path, notice: 'Cannot delete this user'}
      end
    end
  end

  private

  def generate_password(length = 8)
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
    password = ''
    length.times { password << chars[rand(chars.size)] }
    password + 'K0'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
    @domain = @user.domain
  end

  def set_domain
    @domain = current_user.domain
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :phone_number, entity_ids: [], gstin_ids: [],
                                  branch_ids: [], role_ids: [])
  end
end
