class Subject < ApplicationRecord
  belongs_to :user
  has_many :chapters, dependent: :destroy
  
  validates :name, presence: true, length: {maximum: 30}
  validates :user, presence: true
end