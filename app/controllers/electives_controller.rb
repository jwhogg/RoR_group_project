class ElectivesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  before_action :set_elective, only: %i[ show edit update destroy ]

  authorize_resource


  # GET /electives
  def index
    @electives = Elective.all
  end

  # GET /electives/1
  def show
  end

  # GET /electives/new
  def new
    if current_user.admin?
      @elective = Elective.new
    else
      redirect_to electives_path, alert: "You do not have permission to perform this action."
    end
  end

  # GET /electives/1/edit
  def edit
    if current_user.admin?
      # Proceed with the edit action
    else
      redirect_to electives_path, alert: "You do not have permission to perform this action."
    end
  end

  # POST /electives
  def create
    if current_user.admin?
      @elective = Elective.new(elective_params)

      if @elective.save
        redirect_to @elective, notice: "Elective was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to electives_path, alert: "You do not have permission to perform this action."
    end
  end

  # PATCH/PUT /electives/1
  def update
    if current_user.admin?
      if @elective.update(elective_params)
        redirect_to @elective, notice: "Elective was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to electives_path, alert: "You do not have permission to perform this action."
    end
  end

  # DELETE /electives/1
  def destroy
    if current_user.admin?
      @elective = Elective.find(params[:id])
      @elective.questions.destroy_all
      @elective.questions.each { |question| question.destroy }
      @elective.destroy
      redirect_to electives_url, notice: "Elective was successfully destroyed."
    else
      redirect_to electives_path, alert: "You do not have permission to perform this action."
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_elective
      @elective = Elective.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def elective_params
      params.require(:elective).permit(:Title, :Description, :Speciality, :Location, :Accomodation, :WP_Support, :Type)
    end
end
