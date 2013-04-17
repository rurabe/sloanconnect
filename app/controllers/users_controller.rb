class UsersController < ApplicationController
  before_filter :define_client, :only => [:create,:edit]

  def new

  end

  def create
    redirect_to @client.request_token.authorize_url
  end

  def edit
    p "code: " + params[:code].to_s
  end

  private

    def define_client
      @client = LinkedIn::Client.new(ENV["SLOANCONNECT_LINKEDIN_API_KEY"],ENV["SLOANCONNECT_LINKEDIN_SECRET_KEY"])
    end
end
