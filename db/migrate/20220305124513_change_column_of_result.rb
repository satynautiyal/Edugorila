class ChangeColumnOfResult < ActiveRecord::Migration[6.1]
  def change
    remove_column :results,:quiz_id
    add_reference :results, :subject, null: false, foreign_key: true
  end
end
