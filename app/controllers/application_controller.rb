require 'jwt'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    respond_to do |format|
      format.json { render body: { error: 'not_found' }.to_json, status: :not_found }
      format.html { render file: 'public/404', layout: false }
    end
  end
end
