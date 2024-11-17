module JwtHandler
  extend ActiveSupport::Concern

  SECRET_KEY = "Unsigned"

  included do
    before_action :authenticate_user
    attr_reader :current_user
  end

  class_methods do
    def encode_jwt(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY, "HS256")
    end

    def decode_jwt(token)
      decoded_token = JWT.decode(token, SECRET_KEY, true, { algorithm: "HS256" })
      HashWithIndifferentAccess.new(decoded_token[0])
    rescue JWT::DecodeError => e
      raise StandardError.new("Invalid token: #{e.message}")
    end

    def allow_unauthenticated_access(**options)
      skip_before_action :authenticate_user, **options
    end
  end

  private

  def authenticate_user
    token = request.headers["Authorization"]&.split(" ")&.last
    unless token
      render json: { error: "Token missing" }, status: :unauthorized
      return
    end

    begin
      decoded_token = self.class.decode_jwt(token)
      @current_user = User.find(decoded_token[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :unauthorized
    rescue StandardError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end
end
