class UsersController < ApplicationController
    before_filter :define_current_user

  def new
    redirect_to connect_path if @current_user
  end


  def edit
    
  end

  def destroy
    @current_user.destroy
    session[:current_user] = nil
    redirect_to root_path
  end

  private

    def define_current_user
      @current_user = User.find_by_id(session[:current_user])
    end

end
