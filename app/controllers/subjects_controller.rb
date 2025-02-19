class SubjectsController < ApplicationController
 before_action :set_subject, only: [:show, :update, :destroy]
 before_action :authenticate_request

    def index 
        if params[:user_id]
            @subjects = Subject.where(user_id: params[:id])
        else
            @subjects = Subject.all
        end
        respond_to do |format|
            format.html
            format.json {render json: @subjects}
        end
    end

    def show
        respond_to do |format|
            format.html
            format.json {render json: @subject}
        end
    end

    def create 
        @subject = Subject.new(subject_params)

        respond_to do |format|
            if @subject.save
                format.html {redirect_to @subject, notice: "Subject created Successfully"}
                format.json {render json: @subject, status: :created}
            else
                format.html {render :new, staus: :unprocessable_entity}
                format.json {render json: {errors: @subject.errors.full_message }, status: :unprocessable_entity}
            end
        end
    end

    def update
        respond_to do |format|
            if @subject.update(subject_params)
                format.html {redirect_to @subject, notice: "Subject was updated successfully"}
                format.json {render json: @subject}
            else
                format.html {render :edit, status: :unprocessable_entity}
                format.json {render json: {errors: @subject.errors.full_message }, staus: :unprocessable_entity}
            end
        end
    end

    def destroy 
        @subject.destroy

        respond_to do |format|
            format.html {redirect_to subjects_url, notice: "Subject deleted successfully."}
            format.json {render json: {message: "Subject deleted successfully !!"}}
        end
    end




    private
    def subject_params
        params.require(:subject).permit(:name, :user_id)
    end

    def set_subject
        @subject = Subject.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        respond_to do |format|
            format.html {redirect_to subjects_url, alert: "Subject not found"}
            format.json {render json: {error: "Subject not found"}, status: :not_found}
        end 
    end
end
