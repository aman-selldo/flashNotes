class Chapter < ApplicationRecord
  belongs_to :subject
  has_many :paragraphs, dependent: :destroy

  validates :name, presence: true, length: {maximum: 20}
  validates :subject, presence: true
end

