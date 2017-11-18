require 'httparty'
require 'json'

class Kele
  include 'httparty'

  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    post_response = self.class.post('/sessions', body: { email: email, password: password})
    @user_auth_token = post_response['auth_token']
    raise "Email or Password is invalid. Please Try Again." if user_auth_token.nil?
  end

  def get_me
    response = self.class.get('/users/me', headers: { "authorization" => @user_auth_token })
    @data_hash = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get('mentors/#{mentor_id}/student_availability', headers: { "authorization" => @user_auth_token }).to_a
    availability = []
    response.each do |timeslot|
      if timeslot["booked"] == nil
        availability.push(timeslot)
      end
    end
    puts availability
  end


  private

  def api_url(destination)
    "https://www.bloc.io/api/v1/#{destination}"
  end
end
