class Subject < ApplicationRecord
  belongs_to :user
  has_many :chapters, dependent: :destroy
  
  validates :name, presence: true
  validates :user, presence: true
end