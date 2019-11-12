# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    respond_to do |format|
      format.json { render json: { error: 'not_found' }, status: :not_found }
      format.html { render file: 'public/404', layout: false }
    end
  end
end
