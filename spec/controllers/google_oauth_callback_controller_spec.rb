# frozen_string_literal: true

require 'rails_helper'

describe GoogleOauthCallbackController, type: :controller do
  let(:controller) { described_class.new }

  describe 'front_app_url_with_token' do
    subject(:front_app_url) { controller.send(:front_app_url_with_token, request_env) }

    before do
      ENV['FRONT_BASE_URL'] = 'https://moss-front.fr/'

      allow(controller).to receive(:token).and_return('my-access-token')
    end

    context 'URL in redirect_to query param starts with front URL' do
      let(:request_env) do
        {
          'omniauth.params' => {
            'redirect_to' => 'https://moss-front.fr/ma-page-de-redirection/'
          }
        }
      end

      it 'returns the URL given in redirect_to query param' do
        expect(front_app_url).to eq 'https://moss-front.fr/ma-page-de-redirection/#access_token=my-access-token'
      end
    end

    context 'URL in redirect_to query param does not start with front URL' do
      let(:request_env) do
        {
          'omniauth.params' => {
            'redirect_to' => 'https://mon-site-de-hack.er/'
          }
        }
      end

      it 'returns the URL given in redirect_to query param' do
        expect(front_app_url).to eq 'https://moss-front.fr/#access_token=my-access-token'
      end
    end
  end
end
