class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :introduction, :string, null: false, default: ""
  end
end
