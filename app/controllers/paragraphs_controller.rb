class ParagraphsController < ApplicationController
  before_action :authenticate_user
  before_action :set_subject
  before_action :set_chapter
  before_action :set_paragraph, only: [:show, :update, :destroy, :edit]

  def index
    @paragraphs = @chapter.paragraphs
    @chapter = Chapter.find(params[:chapter_id])
    @subject = @chapter.subject
    if params[:search].present?
      @paragraphs = @paragraphs.where("title ILIKE ?", "%#{params[:search]}%")
    end
  end

  def show
    @subject = @chapter.subject
    @questions = @paragraph.questions.includes(:answers)
  end
  
  def create
    @paragraph = @chapter.paragraphs.new(paragraph_params)
    @paragraph.user = current_user
    if @paragraph.save
      redirect_to subject_chapter_paragraphs_path(@chapter.subject, @chapter), notice: "Paragraph created successfully!!" 
    else
      redirect_to subject_chapter_paragraphs_path, alert: "Something went wrong!!"
    end
  end

  def edit
    redirect_to subject_chapter_paragraphs_path
  end

  def update
    if @paragraph.update(paragraph_params)
      redirect_to subject_chapter_paragraphs_path(@chapter.subject, @chapter), notice: "Paragraph updated successfully."
    else
      redirect_to subject_chapter_paragraphs_path, alert: "Something went wrong!!"
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


  def set_subject
    @subject = current_user.subjects.find_by(id: params[:subject_id])
    unless @subject
      redirect_to subjects_path, notice: "Subject not found!!"
      return false
    end 
  end

  def set_chapter
    return unless @subject
    @chapter = @subject.chapters.find_by(id: params[:chapter_id])
    unless @chapter
      redirect_to subject_chapters_path(@subject), notice: "Chapter not found!!"
      return false
    end
  end
  
  def set_paragraph
    return unless @chapter
    if current_user.presence
      @paragraph = @chapter.paragraphs.find_by(id: params[:id])
    else
      redirect_to login_path, notice: "Something went wrong!!"
      return false
    end
    unless @paragraph
      redirect_to subject_chapter_paragraphs_path(@subject, @chapter), notice: "Paragraph not found!!"
      return false
    end
  end
  
  def authenticate_user
    unless current_user
      redirect_to login_path, notice: "You need to login first"
      return false
    end
  end
end
