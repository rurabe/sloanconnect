require 'net/http'

module LinkedIn
  class Api

    REDIRECT_URI = Rails.env.production? ? "http://sloanconnect.herokuapp.com/authorized" : "http://localhost:3000/authorized"

    def self.authorization_url
      client.auth_code.authorize_url(
        :scope        => "r_emailaddress w_messages",
        :state        => SecureRandom.urlsafe_base64(16),
        :redirect_uri => REDIRECT_URI
      )
    end

    def self.get_profile(options={})
      stock_token = request_access_token( options[:authorization_code] )
      request_token = access_token( stock_token.token )
      response = request_token.get('https://www.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,public-profile-url)')
      parse_response( response ).merge( :linkedin_token => stock_token.token, :linkedin_token_expires_at => stock_token.expires_at )
    end

    def self.connect(options={}) # {:user => User.find(1), :connection => User.find(2)}
      request_token = access_token( options[:user].linkedin_token )
      params = invitation_params( options[:connection] )
      request_token.post( "https://api.linkedin.com/v1/people/~/mailbox", { 
        :headers => {'Content-Type' => 'application/json'}, 
        :body => params } 
      )
    end

    # Essentially private methods

      def self.client
        OAuth2::Client.new(
           ENV['SLOANCONNECT_LINKEDIN_API_KEY'], 
           ENV['SLOANCONNECT_LINKEDIN_SECRET_KEY'], 
           :authorize_url => "/uas/oauth2/authorization?response_type=code", #LinkedIn's authorization path
           :token_url => "/uas/oauth2/accessToken", #LinkedIn's access token path
           :site => "https://www.linkedin.com",
           :raise_errors => false,
         )
      end

      def self.request_access_token(authorization_code)
        client.auth_code.get_token(authorization_code, :redirect_uri => REDIRECT_URI)
      end

      def self.access_token(token)
        OAuth2::AccessToken.new(client, token, {
          :mode       => :query,
          :param_name => "oauth2_access_token",
        })
      end

      def self.parse_response(response)
        xml_response = Nokogiri::XML(response.body)
        parse_attributes( xml_response )
      end

      def self.parse_attributes(xml)
        {
          :first_name          => parse_xml(xml,"//first-name"),
          :last_name           => parse_xml(xml,"//last-name"),
          :linkedin_url        => parse_xml(xml,"//url"),
          :linkedin_id         => parse_xml(xml,"//id"),
          :email               => parse_xml(xml,"//email-address"),
        }
      end

      def self.parse_xml(xml,xpath)
        node = xml.search(xpath)
        node.text if node
      end

      def self.parse_url(url,regex)
        match = url.match(regex)
        match[1] if match
      end

      def self.invitation_params(user)
        {
          "recipients" => {
            "values" => [
            {
              "person" => {
                "_path" => "/people/email=#{user.email}",
                "first-name" => user.first_name,
                "last-name" => user.last_name
              }
            }]
          },
          "subject" => "SloanConnect invitation to connect.",
          "body" => "We're classmates!",
          "item-content" => {
            "invitation-request" => {
              "connect-type" => "friend"
            }
          }
        }.to_json
      end
  end
end