class FeedbacksController < ApplicationController

  # GET /contacts/new
  def new
    @feedback = Feedback.new
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @feedback = Feedback.new(feedback_params)
    respond_to do |format|
      if @feedback.save
        format.html { redirect_to root_path, notice: 'Your feedback is successfully submitted.' }
        format.json { render :show, status: :created, location: @feedback }
      else
        format.html { render :new }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:name, :mobile_number,
                                      :email, :comment, :domain)
    end
end
