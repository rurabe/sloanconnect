class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :linkedin_token
      t.string :linkedin_id
      t.string :linkedin_auth_token
      t.text :linkedin_url

      t.timestamps
    end
  end
end
