class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :linkedin_id, :linkedin_token, :linkedin_token_expires_at, :linkedin_url

  def full_name
    "#{first_name} #{last_name}"
  end
end
