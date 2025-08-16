class ParagraphsController < ApplicationController
  before_action :authenticate_user
  before_action :set_subject
  before_action :set_chapter
  before_action :set_paragraph, only: [:show, :update, :destroy, :edit]

  def index
    @paragraphs = @chapter.paragraphs.order(updated_at: :desc)
    @chapter = Chapter.find(params[:chapter_id])
    @subject = @chapter.subject
    if params[:search].present?
      @paragraphs = @paragraphs.where("title ILIKE ?", "%#{params[:search]}%")
    end

    # Pagination
    @per_page = 6
    @current_page = params[:page].to_i
    @current_page = 1 if @current_page < 1
    @total_count = @paragraphs.count
    @total_pages = (@total_count / @per_page.to_f).ceil
    if @total_pages > 0 && @current_page > @total_pages
      @current_page = @total_pages
    end
    offset_value = (@current_page - 1) * @per_page
    @paragraphs = @paragraphs.offset(offset_value).limit(@per_page)
  end

  def show
    @questions = @paragraph.questions.includes(:answers).order(updated_at: :desc)

    # Pagination for questions
    # @per_page = 6
    # @current_page = params[:page].to_i
    # @current_page = 1 if @current_page < 1
    # @total_count = @questions.count
    # @total_pages = (@total_count / @per_page.to_f).ceil
    # if @total_pages > 0 && @current_page > @total_pages
    #   @current_page = @total_pages
    # end
    # offset_value = (@current_page - 1) * @per_page
    # @questions = @questions.offset(offset_value).limit(@per_page)
  end

  def create
    @paragraph = @chapter.paragraphs.new(paragraph_params)
    @paragraph.user = current_user
    if @paragraph.save
      number = params[:paragraph][:number].to_i
      res = generate_questions_and_answers(@paragraph, number)
      redirect_to subject_chapter_paragraph_path(@chapter.subject, @chapter, @paragraph), notice: "Paragraph created successfully with #{number} flashcards!"
    else
      redirect_to subject_chapter_paragraphs_path(@chapter.subject, @chapter), alert: flash[:alert] = @paragraph.errors.full_messages.to_sentence
    end
  end

  def edit
    redirect_to subject_chapter_paragraphs_path
  end

  def update
    if @paragraph.update(paragraph_params)
      # Check if Gemini generation is enabled and number is specified
      # Note: These fields are disabled in edit form, so they won't be submitted
      if params[:paragraph][:generate_with_gemini] == "1" && params[:paragraph][:number].present?
        number = params[:paragraph][:number].to_i
        if number > 0
          # Destroy existing questions if content changed, otherwise keep them
          if @paragraph.saved_change_to_content?
            @paragraph.questions.destroy_all
          end
          res = generate_questions_and_answers(@paragraph, number)
          redirect_to subject_chapter_paragraph_path(@chapter.subject, @chapter, @paragraph), notice: "Paragraph updated successfully with #{number} new flashcards."
        else
          redirect_to subject_chapter_paragraph_path(@chapter.subject, @chapter, @paragraph), notice: "Paragraph updated successfully. No flashcards generated (number not specified)."
        end
      else
        # No Gemini generation requested (or fields disabled)
        if @paragraph.saved_change_to_content?
          redirect_to subject_chapter_paragraph_path(@chapter.subject, @chapter), notice: "Paragraph updated successfully."
        else
          redirect_to subject_chapter_paragraphs_path(@chapter.subject, @chapter), notice: "Paragraph updated successfully."
        end
      end
    else
      redirect_to subject_chapter_paragraphs_path(@chapter.subject, @chapter), alert: @paragraph.errors.full_messages.to_sentence
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
    params.require(:paragraph).permit(:title, :content, :number)
  end


  def set_subject
    @subject = current_user.subjects.find_by(id: params[:subject_id])
    unless @subject
      redirect_to subjects_path, alert: "Subject not found!!"
      return false
    end
  end

  def set_chapter
    return unless @subject
    @chapter = @subject.chapters.find_by(id: params[:chapter_id])
    unless @chapter
      redirect_to subject_chapters_path(@subject), alert: "Chapter not found!!"
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
      redirect_to subject_chapter_paragraphs_path(@subject, @chapter), alert: "Paragraph not found!!"
      return false
    end
  end

  def authenticate_user
    unless current_user
      redirect_to login_path, notice: "You need to login first"
      return false
    end
  end


  def generate_questions_and_answers(paragraph, number)
    gemini_service = GeminiService.new
    response_text = gemini_service.generate_questions_and_answers(paragraph.content, number)
    
    Rails.logger.info "Gemini service returned: #{response_text.inspect}"
    
    if response_text.present? && response_text.is_a?(Array) && response_text.length > 0
      begin
        created_questions = []
        
        response_text.each do |h|
          Rails.logger.info "Processing hash: #{h.inspect}"
          
          # Validate that we have both question and answer
          if h[:question].present? && h[:answer].present?
            # Create question with nested answer attributes to avoid validation error
            question = paragraph.questions.create!(
              question: h[:question],
              answers_attributes: [{ answer: h[:answer] }]
            )
            
            created_questions << { question: question, answer: question.answers.first }
            Rails.logger.info "Created question: #{question.id} with answer: #{question.answers.first.id}"
          else
            Rails.logger.warn "Skipping invalid question/answer pair: #{h.inspect}"
          end
        end
        
        Rails.logger.info "Successfully created #{created_questions.length} questions"
        return created_questions
      rescue => e
        Rails.logger.error "Error parsing questions & answers: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        return []
      end
    else
      Rails.logger.error "No valid response from Gemini API or empty array returned"
      return []
    end
  end
end
