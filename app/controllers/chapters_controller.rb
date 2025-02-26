class ChaptersController < ApplicationController

	before_action :set_subject

	before_action :set_chapter, only: [:show, :update, :destroy, :edit]


	def index
		@chapters = @subject.chapters
	end
	
	def show
		@subject = Subject.find(params[:subject_id])
		@chapter = @subject.chapters.find(params[:id])
		redirect_to subject_chapter_paragraphs_path(@subject.id, @chapter.id)
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
		@subject = Subject.find(params[:subject_id])
		@chapter = @subject.chapters.find(params[:id])
	end

	def update
		if @chapter.update(chapter_params)
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

		unless @subject
			redirect_to subjects_path, notice: "Subject not found!!"
		end
	end

	def set_chapter
		return unless params[:id]

		unless @subject
			redirect_to subjects_path, notice: "Subject not found!!" and return
		end

		@chapter = @subject.chapters.find_by(id: params[:id])

		unless @chapter
			redirect_to subject_chapters_path(@subject), notice: "Chapter not found!!" and return
		end
	end

	def chapter_params
		params.require(:chapter).permit(:name)
	end

end
