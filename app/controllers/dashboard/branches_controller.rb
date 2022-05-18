class Dashboard::BranchesController < Dashboard::DashboardController
  before_action :set_branch, only: [:show, :update, :destroy, :edit]
  load_and_authorize_resource except: [:create]

  # GET /branches
  # GET /branches.json
  def index
    @branches = Branch.accessible_by(current_ability)
  end

  # GET /branches/1
  # GET /branches/1.json
  def show
  end

  def new
    @branch = Branch.new
    @gstins = Gstin.accessible_by(current_ability)
    @entities = Entity.accessible_by(current_ability)
    @entity_id_to_gstin = @gstins.group_by(&:entity_id)
  end

  def edit
    @gstins = Gstin.accessible_by(current_ability)
    @entities = Entity.accessible_by(current_ability)
  end

  # POST /branches
  # POST /branches.json
  def create
    @branch = Branch.new(branch_params)
    respond_to do |format|
      if @branch.save
        format.html { redirect_to dashboard_branches_path, notice: 'Branch was successfully created.' }
        format.json { render :show, status: :created, location: @branch }
      else
        format.html { render :new }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /branches/1
  # PATCH/PUT /branches/1.json
  def update
    respond_to do |format|
      if @branch.update(branch_params)
        format.html { redirect_to  dashboard_branches_path, notice: 'Branch was successfully updated.' }
        format.json { render :show, status: :created, location: @branch }
      else
        format.html { render :new }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1
  # DELETE /branches/1.json
  def destroy
    @branch.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_branch
      @branch = Branch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def branch_params
      params.require(:branch).permit(:name, :address, :location, :gstin_id, :entity_id)
    end
end
