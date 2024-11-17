class UsersController < ApplicationController
  allow_unauthenticated_access

  def sign_up
    service = ::Users::SignUp.new(params: user_params).perform
    render body: "User created.", status: :created if service.persisted?
  end

  private

  def user_params
    params.permit(:email_address, :password, :password_confirmation)
  end
end
