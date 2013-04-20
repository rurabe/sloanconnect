class AddIndexesToUser < ActiveRecord::Migration
  def change
    add_index :users, [:first_name, :last_name], :unique => true
    add_index :users, :linkedin_id
  end
end
