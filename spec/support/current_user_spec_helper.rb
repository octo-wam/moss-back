# frozen_string_literal: true

module Request
  module CurrentUserSpecHelper
    def current_user_id
      '208294780284604222681'
    end

    def current_user_token
      {
        'name' => 'Test User',
        'email' => 'testuser@octo.com',
        'exp' => Time.zone.now.to_i + 10,
        'sub' => current_user_id,
        'photo' => 'https://photos.fr/test-user.jpg'
      }
    end

    def save_current_user
      before do
        create :user,
               id: current_user_token['sub'],
               name: current_user_token['name'],
               email: current_user_token['email'],
               photo: current_user_token['photo']
      end
    end

    def headers_of_logged_in_user
      allow(JWT).to receive(:decode).and_return([current_user_token])
      { AUTHORIZATION: 'Bearer WhateverToken' }
    end
  end
end
