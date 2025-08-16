module ChaptersHelper
  def label_badge_class(label)
    case label
    when 'priority' then 'bg-danger'
    when 'pending' then 'bg-warning text-dark'
    when 'in_progress' then 'bg-info text-dark'
    when 'completed' then 'bg-success'
    when 'backlog' then 'bg-secondary'
    else 'bg-secondary'
    end
  end

  def default_label(label)
    return 'No label' if label.blank?
    Chapter::LABELS[label] || label.to_s.tr('_', ' ').titleize
  end
end
