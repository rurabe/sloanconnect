class LinkedInController < ApplicationController
  def create
    redirect_to LinkedIn::Api.authorization_url
  end

  def show
    profile_data =  LinkedIn::Api.get_profile( :authorization_code => params[:code] )
    assign_user(profile_data)
    redirect_to connect_path
  end

  private

    def assign_user(profile_data)
      @user = User.find_or_initialize_by_first_name_and_last_name( profile_data )
      @user.assign_attributes( profile_data ) unless @user.new_record?
      @user.save
      session[:current_user] = @user.id
    end

end
