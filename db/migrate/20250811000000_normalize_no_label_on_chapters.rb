class NormalizeNoLabelOnChapters < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      UPDATE chapters
      SET label = 'no_label'
      WHERE label IS NULL OR trim(label) = '';
    SQL
  end

  def down
    # No-op: cannot reliably revert which records were blank vs intentionally 'no_label'
  end
end 