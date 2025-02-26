class QuestionsController < ApplicationController
  before_action :set_paragraph
  before_action :set_question, only: [:edit, :update, :destroy, :index]

  def new
    @question = @paragraph.questions.new
  end

  def create
    @question = @paragraph.questions.new(question_params)
    if @question.save
      redirect_to subject_chapter_paragraph_path(@paragraph.chapter.subject, @paragraph.chapter, @paragraph), notice: "Question added successfully."
    else
      render :new, alert: "Failed to add question."
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to subject_chapter_paragraph_path(@paragraph.chapter.subject, @paragraph.chapter, @paragraph), notice: "Question updated successfully."
    else
      render :edit, alert: "Failed to update question."
    end
  end

  def destroy
    @question.destroy
    redirect_to subject_chapter_paragraph_path(@paragraph.chapter.subject, @paragraph.chapter, @paragraph), notice: "Question deleted successfully."
  end

  private

  def set_paragraph
    @paragraph = Paragraph.find(params[:paragraph_id])

    unless @paragraph
      redirect_to subject_chapter_paragraphs_path, notice: "Content not found!!"
    end
  end

  def set_question
    @question = @paragraph.questions.find(params[:id])

    unless @question
      redirect_to subject_chapter_paragraphs_path, notice: "Content not found!!"
    end 
  end

  def question_params
    params.require(:question).permit(:question)
  end
end
