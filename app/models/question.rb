class Question < ApplicationRecord
  belongs_to :paragraph
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true, reject_if: proc { |attrs| attrs["answer"].blank? }

  validates :paragraph, presence: true
  validates :question, presence: true
  validate :at_least_one_answer

  private

  def at_least_one_answer
    if answers.empty? || answers.all? { |answer| answer.answer.blank? }
      errors.add(:base, "At least one answer is required")
    end
  end
end
