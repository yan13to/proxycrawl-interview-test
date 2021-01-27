# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    before_action :authenticate_user_from_token!
    helper_method :current_user

    def current_user
      @current_user
    end

    private

    def authenticate_user_from_token!
      user_email = params[:email].presence
      user = user_email && User.find_by_email(user_email)

      if user && Devise.secure_compare(user.authentication_token, params[:token])
        @current_user = user
        sign_in user, store: false
      else
        @current_user = nil
        render json: { errors: 'Unauthorized' }, status: :unauthorized
      end
    end
  end
end
