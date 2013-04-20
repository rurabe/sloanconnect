class AddTokenExpiresAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :linkedin_token_expires_at, :integer
  end
end
