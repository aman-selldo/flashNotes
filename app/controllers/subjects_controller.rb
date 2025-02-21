class SubjectsController < ApplicationController
  
  before_action :set_subject, only: [:show, :edit, :update, :destroy, :index, :new]

  def index
    @subjects = current_user.subjects
  end

  def show
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = current_user.subjects.build(subject_params)
    if @subject.save
      redirect_to subjects_path, notice: "Subject was created successfully"
    else
      render :new
    end
  end

  def edit
    
  end

  def update
    if @subject.update(subject_params)
      redirect_to subjects_path, notice: "Subject updated successfully!!"
    else
      render :edit
    end
  end

  def destroy    
    @subject.destroy
    redirect_to subjects_path, notice: "Subject deleted Successfully"
  end

  private

  def subject_params
    params.require(:subject).permit(:name)
  end

  def set_subject
    if current_user.present?
      @subject = current_user.subjects.find_by(id: params[:id])
    else
      redirect_to login_path, notice: "Something went wrong"
    end
  end

  def authenticate_user
    unless current_user
      redirect_to login_path, notice: "You need to login first"
    end
  end

end
