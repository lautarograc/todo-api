module AuthHelper
  def auth_headers
    @current_user ||= create(:user)
    token = JWT.encode(@current_user.id, "Unsigned", "HS256")
    { 'Authorization' => "Bearer #{token}" }
  end

  def current_user
    @current_user
  end
end
