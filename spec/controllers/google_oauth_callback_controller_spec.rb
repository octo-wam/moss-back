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

      it 'returns an URL that is not redirect_to query param' do
        expect(front_app_url).to eq 'https://moss-front.fr/#access_token=my-access-token'
      end
    end
  end

  describe 'upsert_user' do
    subject(:upsert_user) { controller.send(:upsert_user) }

    let(:auth_info_sub) { '123456789' }
    let(:auth_info) do
      {
        'info' => { 'email' => 'jean.paul@email.com', 'name' => 'Jean Paul' },
        'extra' => {
          'raw_info' => { 'sub' => auth_info_sub, 'picture' => 'https://photos.fr/jean-paul.jpg' }
        }
      }
    end

    before { controller.instance_variable_set :@auth_info, auth_info }

    context 'user is not already in the database' do
      it 'creates the user' do
        expect { upsert_user }.to change(User, :count).by(1)
      end

      it 'assigns accurate attributes to the new user' do
        upsert_user

        last_user = User.last
        expect(last_user.id).to eq auth_info_sub
        expect(last_user.name).to eq 'Jean Paul'
        expect(last_user.email).to eq 'jean.paul@email.com'
        expect(last_user.photo).to eq 'https://photos.fr/jean-paul.jpg'
      end
    end

    context 'user is already in the database' do
      before do
        create :user, id: auth_info_sub, name: 'Jacques', email: 'jacques@email.com', photo: nil
        create :user, id: '987654321', name: 'Nabil', email: 'nabil@email.com', photo: nil
      end

      it 'does not create a user' do
        expect { upsert_user }.not_to change(User, :count)
      end

      it 'updates accurate attributes to user (changes Jacques for Jean Paul)' do
        upsert_user

        authenticated_user = User.find(auth_info_sub)
        expect(authenticated_user.name).to eq 'Jean Paul'
        expect(authenticated_user.email).to eq 'jean.paul@email.com'
        expect(authenticated_user.photo).to eq 'https://photos.fr/jean-paul.jpg'
      end
    end
  end
end
