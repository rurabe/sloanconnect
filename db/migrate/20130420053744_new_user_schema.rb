class NewUserSchema < ActiveRecord::Migration
  def change
    add_column :users, :email, :string
    remove_column :users, :linkedin_auth_token
  end
end
