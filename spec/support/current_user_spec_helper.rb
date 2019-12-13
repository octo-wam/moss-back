# frozen_string_literal: true

module Request
  module CurrentUserSpecHelper
    def current_user_id
      '208294780284604222681'
    end

    def current_user
      {
        'name' => 'Test User',
        'email' => 'testuser@octo.com',
        'exp' => Time.zone.now.to_i + 10,
        'sub' => current_user_id
      }
    end

    def headers_of_logged_in_user
      allow(JWT).to receive(:decode).and_return([current_user])
      { AUTHORIZATION: 'Bearer WhateverToken' }
    end
  end
end
