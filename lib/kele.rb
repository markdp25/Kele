require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    post_response = self.class.post('/sessions', body: { email: email, password: password})
    @user_auth_token = post_response['auth_token']
    raise "Email or Password is invalid. Please Try Again." if @user_auth_token.nil?
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

  def get_messages(page = nil)
        if page
          response = self.class.get('/message_threads',
            headers: { "authorization" => @user_auth_token },
            body: { page: page })
        else
          response = self.class.get('/message_threads',
            headers: { "authorization" => @user_auth_token })
        end
      JSON.parse(response.body)
    end

  def create_message(sender, recipient_id, token = nil, subject, stripped_text)
    response = self.class.get('/messages',
    headers: { "authorization" => @user_auth_token },
    body: {
      sender: sender,
      recipient_id: recipient_id,
      token: token,
      subject: subject,
      stripped_text: stripped_text
      })
  end


  private

  def api_url(destination)
    "https://www.bloc.io/api/v1/#{destination}"
  end
end
