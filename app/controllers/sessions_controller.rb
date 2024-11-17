class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      token = self.class.encode_jwt(id: user.id, email: user.email_address, exp: 1.day.from_now.to_i)
      render json: { data: { token: token  } }
    else
      render json: {}, status: :unauthorized
    end
  end
end
