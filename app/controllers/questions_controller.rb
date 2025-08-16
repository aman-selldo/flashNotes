class QuestionsController < ApplicationController
  before_action :authenticate_user
  before_action :set_subject
  before_action :set_chapter
  before_action :set_paragraph

  def create
    success_count = 0
    error_messages = []
    created_questions = []
    if params[:questions].present?
      params[:questions].each do |index, question_data|
        question = @paragraph.questions.new(question: question_data[:question])
        answer = question.answers.new(answer: question_data[:answer])
        if question.save && answer.save
          success_count += 1
          created_questions << {
            id: question.id,
            question: question.question,
            answer: answer.answer
          }
        else
          error_messages << "Set #{index.to_i + 1}: #{question.errors.full_messages.to_sentence}"
        end
      end
    end
    respond_to do |format|
      format.html do
        if success_count > 0
          if error_messages.any?
            redirect_to subject_chapter_paragraph_path(@subject, @chapter, @paragraph), 
                        notice: "#{success_count} flashcard(s) created successfully. Some failed: #{error_messages.join(', ')}"
          else
            redirect_to subject_chapter_paragraph_path(@subject, @chapter, @paragraph), 
                        notice: "#{success_count} flashcard(s) created successfully!"
          end
        else
          redirect_to subject_chapter_paragraph_path(@subject, @chapter, @paragraph), 
                      alert: "Failed to create flashcards: #{error_messages.join(', ')}"
        end
      end

      format.json do
        if success_count > 0
          render json: {
            success: true,
            message: "#{success_count} flashcard(s) created successfully!",
            questions: created_questions,
            errors: error_messages
          }
        else
          render json: {
            success: false,
            message: "Failed to create flashcards: #{error_messages.join(', ')}"
          }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def question_params
    params.require(:questions).permit!
  end

  def set_subject
    @subject = current_user.subjects.find_by(id: params[:subject_id])
    unless @subject
      redirect_to subjects_path, alert: "Subject not found!"
      return false
    end
  end

  def set_chapter
    return unless @subject
    @chapter = @subject.chapters.find_by(id: params[:chapter_id])
    unless @chapter
      redirect_to subject_chapters_path(@subject), alert: "Chapter not found!"
      return false
    end
  end

  def set_paragraph
    return unless @chapter
    @paragraph = @chapter.paragraphs.find_by(id: params[:paragraph_id])
    unless @paragraph
      redirect_to subject_chapter_paragraphs_path(@subject, @chapter), alert: "Paragraph not found!"
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