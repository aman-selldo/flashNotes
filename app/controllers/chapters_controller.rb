class ChaptersController < ApplicationController

	before_action :set_subject, only: [:index, :show, :update, :destroy, :create, :new]

	before_action :set_chapter, only: [:index, :show, :update, :destroy, :create]


	def index
		@chapters = @subject.chapters
	end
	
	def show
		@subject = Subject.find(params[:subject_id])
		@chapter = @subject.chapters.find(params[:id])
	end

	def new
		@subject = Subject.find(params[:subject_id])
		@chapter = @subject.chapters.new
	end

	def create
		@chapter = @subject.chapters.new(chapter_params)
		if @chapter.save
			redirect_to subject_chapters_path(@subject), notice: "Chapter created successfully!!"
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @chapter.update(chapter_parameter)
			redirect_to subject_chapters_path(@subject), notice: "Chapter updated successfully!!"
		else
			render :edit
		end
	end

	def destroy		
		@chapter.destroy
		redirect_to subject_chapters_path(@subject), notice: "Chapter deleted successfully!!"
	end

	private

	def set_subject
		@subject = Subject.find_by(id: params[:subject_id])
		redirect_to subject_path, notice: "Subject not found!!" if @subject.nil?
	end

	def set_chapter
		@chapter = @subject.chapters.find_by(id: params[:id])
	end

	def chapter_params
		params.require(:chapter).permit(:name)
	end

end
