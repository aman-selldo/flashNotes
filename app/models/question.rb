class Question < ApplicationRecord
  belongs_to :paragraph

  validates :paragraph, presence: true
  validates :question, presence: true
end
