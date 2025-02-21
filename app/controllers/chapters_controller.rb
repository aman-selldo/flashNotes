class ChaptersController < ApplicationController

	def index
		@chapters = @subject.chapters
	end
	
	def show
	end

	def new
		@chapter = @subject.chapters.new
	end

	def create
		@chapter = @subject.chapters.new()
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
		@subject = Subject.find(params[:subject_id])
	end

	def set_chapter
		@chapter = @subject.chapter.find(params[:id])
	end

	def chapter_params
		params.require(:chapter).permit(:name)
	end

end
