class HomepageController < ApplicationController 
  # GET /
  def index
    # we never want to user to go to homepage
    redirect_to dashboard_path
  end

  def terms_conditions
  end

  def privacy_policies
  end

  def legal_policies
  end

  def accessability
  end

  def faq
  end

  def whats_new
  end
end
