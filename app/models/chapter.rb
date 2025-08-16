class Chapter < ApplicationRecord
  belongs_to :subject
  has_many :paragraphs, dependent: :destroy

  LABELS = {
    'priority' => 'Priority',
    'pending' => 'Pending',
    'in_progress' => 'In Progress',
    'completed' => 'Completed',
    'backlog' => 'Backlog',
    'no_label' => 'No label'
  }.freeze

  before_validation :normalize_label

  validates :name, presence: true
  validates :subject, presence: true
  validates :description, presence: true, length: { minimum: 5, maximum: 50}
  validates :label, inclusion: { in: LABELS.keys }, allow_nil: true

  private

  def normalize_label
    self.label = 'no_label' if label.blank?
  end
end
