require 'httparty'

class Kele
  include 'httparty'

  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    post_response = self.class.post('/sessions', body: { email: email, password: password})
    @user_auth_token = post_response['auth_token']
    raise "Email or Password is invalid. Please Try Again." if user_auth_token.nil?
  end
end
