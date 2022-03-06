class AddColumnsToSubject < ActiveRecord::Migration[6.1]
  def change
    add_column :subjects, :duration, :integer
  end
end
