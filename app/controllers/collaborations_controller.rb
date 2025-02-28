class CollaborationsController < ApplicationController
  before_action :set_subject
  before_action :set_collaboration, only: [:update, :destroy]

  def index
    @collaborations = @subject.collaborations
  end

  def create
    username = params[:username]
    user = User.find_by(username: username)
    
    unless user
      redirect_to subject_path(@subject), alert: "User with that email not found"
      return
    end
    
    @collaboration = @subject.collaborations.new(
      user_id: user.id,
      owner_id: current_user.id,
      status: "pending",
      access_level: params[:access_level]
    )

    if @collaboration.save
      redirect_to subject_path(@subject), notice: "Collaboration request sent!" 
    else
      flash.now[:alert] = @collaboration.errors.full_messages.to_sentence
      redirect_to subject_path(@subject), alert: @collaboration.errors.full_messages.to_sentence
    end
  end

  def update
    if params[:status].present?
      @collaboration.update(status: params[:status])
    elsif params[:access_level].present?
      @collaboration.update(access_level: params[:access_level])
    end
    redirect_to subject_path(@subject), notice: "Collaboration updated"
  end

  def destroy
    @collaboration.destroy
    redirect_to subject_path(@subject), notice: "Collaboration removed!"
  end

  private

  def set_collaboration
    @collaboration = @subject.collaborations.find(params[:id])
  end

  def set_subject
    @subject = Subject.find(params[:subject_id])
  end
end