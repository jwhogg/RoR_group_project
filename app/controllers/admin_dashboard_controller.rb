class AdminDashboardController < ApplicationController
  load_and_authorize_resource class: Question, except: :index

  def index
    @questions = Question.where(approved: false)
    @answers = Answer.where(approved: false)
  end
  
    private
  
    def authenticate_admin
      unless current_user && current_user.admin?
        redirect_to root_path, alert: 'You do not have permission to access this page.'
      end
    end
  end
  