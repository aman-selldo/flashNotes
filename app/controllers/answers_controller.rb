class AnswersController < ApplicationController
  before_action :set_question
  before_action :set_answer, only: [:edit, :update, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to subject_chapter_paragraph_path(@question.paragraph.chapter.subject, @question.paragraph.chapter, @question.paragraph), notice: "Answer added successfully."
    else
      redirect_to subject_chapter_paragraph_path(@question.paragraph.chapter.subject, @question.paragraph.chapter, @question.paragraph), alert: "Failed to add answer."
    end
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to subject_chapter_paragraph_path(@question.paragraph.chapter.subject, @question.paragraph.chapter, @question.paragraph), notice: "Answer updated successfully."
    else
      render :edit, alert: "Failed to update answer."
    end
  end

  def destroy
    @answer.destroy
    redirect_to subject_chapter_paragraph_path(@question.paragraph.chapter.subject, @question.paragraph.chapter, @question.paragraph), notice: "Answer deleted successfully."
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:answer)
  end
end
