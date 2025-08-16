class Paragraph < ApplicationRecord
  before_save :sanitize_content

  belongs_to :chapter
  belongs_to :user
  
  has_many :questions, dependent: :destroy
  
  validates :chapter, presence: true
  validates :user, presence: true
  validates :title, presence: true, length: {maximum: 40}
  validates :content, presence: true
  validates :number, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }, allow_nil: true

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: proc { |attrs| attrs["question"].blank? }

  private

  def sanitize_content
    self.content = ActionController::Base.helpers.sanitize(
      content,
      tags: %w(p br strong em ul ol li),
      attributes: %w(id class)
    )
  end
end
