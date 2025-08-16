class AddDescriptionToChapters < ActiveRecord::Migration[8.0]
  def change
    add_column :chapters, :description, :text
  end
end
