class Paragraph < ApplicationRecord
  belongs_to :chapter
  belongs_to :user
  
  has_many :questions, dependent: :destroy
  
  validates :chapter, presence: true
  validates :user, presence: true
  validates :title, presence: true, length: {maximum: 20}
  validates :content, presence: true

end