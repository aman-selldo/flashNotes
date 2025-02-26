class ParagraphsController < ApplicationController
  before_action :set_chapter
  before_action :set_paragraph, only: [:show, :update, :destroy, :edit]

  def index
    @paragraphs = @chapter.paragraphs
  end

  def show
    @subject = @chapter.subject
    @questions = @paragraph.questions.includes(:answers) # Preload answers to avoid N+1 queries
  end
  

  def new
    @paragraph = @chapter.paragraphs.new
  end

  def create
    @paragraph = @chapter.paragraphs.new(paragraph_params)
    @paragraph.user = current_user
    if @paragraph.save
      redirect_to subject_chapter_paragraph_path(@chapter.subject, @chapter, @paragraph), notice: "Paragraph created successfully!!" 
    else
      render :new, alert: "Something went wrong!!"
    end
  end

  def edit
  end

  def update
    if @paragraph.update(paragraph_params)
      redirect_to subject_chapter_paragraphs_path(@chapter.subject, @chapter, @paragraph), notice: "Paragraph updated successfully."
    else
      render :edit, alert: "Something went wrong!!"
    end
  end

  def destroy
    if @paragraph.destroy
      redirect_to subject_chapter_paragraphs_path(@chapter.subject, @chapter), notice: "Paragraph deleted successfully!!"
    else
      redirect_to subject_chapter_paragraph_path(@chapter.subject, @chapter, @paragraph), alert: "Failed to delete paragraph."
    end
  end

  private

  def paragraph_params
    params.require(:paragraph).permit(:title, :content)
  end


  def set_subject ;end

  def set_chapter
    @chapter = Chapter.find_by(id: params[:chapter_id])

    unless @chapter
      redirect_to subject_chapters_path, notice: "Chapter not found!!"
    end
  end
  
  def set_paragraph
    if current_user.presence
      @paragraph = @chapter.paragraphs.find_by(id: params[:id])
    else
      redirect_to login_path, notice: "Something went wrong!!" and return
    end
    unless @paragraph
      redirect_to subject_chapter_paragraphs_path(@chapter.subject, @chapter), notice: "Paragraph not found!!" and return
    end
  end  
end
