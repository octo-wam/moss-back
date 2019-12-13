# frozen_string_literal: true

module Request
  module SwaggerAccessTokenHelper
    include CurrentUserSpecHelper

    def access_token
      JWT.encode(current_user, ENV['SECRET_KEY_BASE'], 'HS256')
    end
  end
end
