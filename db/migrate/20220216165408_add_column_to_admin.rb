class AddColumnToAdmin < ActiveRecord::Migration[6.1]
  def change
    add_column :admins, :phone_number, :string
    add_column :admins, :password_digest, :string
    remove_column :profiles, :phone_no
  end
end
