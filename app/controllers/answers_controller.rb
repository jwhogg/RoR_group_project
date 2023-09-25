class AnswersController < ApplicationController
    before_action :set_question, only: [:create]
    before_action :set_answer, only: [:destroy]
  
    def create
        @question = Question.find(params[:question_id])
        @answer = @question.answers.build(answer_params)
      
        if @answer.save
          redirect_to @question, notice: 'Answer was successfully created.'
        else
          render 'questions/show'
        end
      end
      
      def index
        @question = Question.find(params[:question_id])
        @answers = @question.answers.where(approved: true)
      end

      def approve
        @answer = Answer.find(params[:id])
        @answer.update(approved: true)
        redirect_to admin_dashboard_path, notice: 'Answer approved.'
      end

      def destroy
        @answer = Answer.find(params[:id])
        @answer.destroy
        redirect_to admin_dashboard_path, notice: 'Answer denied and deleted.'
      end
            
    private
  
    def set_question
      @question = Question.find(params[:question_id])
    end
  
    def set_answer
      @answer = Answer.find(params[:id])
    end
  
    def answer_params
      params.require(:answer).permit(:body)
    end
  end