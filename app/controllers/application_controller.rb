class ApplicationController < ActionController::API
  include JwtHandler

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotDestroyed, with: :record_invalid
  rescue_from ActiveRecord::RecordNotUnique, with: :record_uniq
  rescue_from ActiveRecord::InvalidForeignKey, with: :conflict

  def not_found(exception)
    json_response(response: { message: "Not Found", object: exception.model, id: exception.id },
                  status: :not_found)
  end

  def record_invalid(invalid)
    json_response(response: { message: invalid.record.errors }, status: :unprocessable_entity)
  end

  def record_uniq
    json_response(response: { message: "Duplicated attributes" }, status: :unprocessable_entity)
  end

  def conflict(invalid)
    json_response(response: { message: "Conflicting param", object: invalid }, status: :conflict)
  end

  def json_response(response:, status: :ok)
    Rails.logger.debug(response.inspect) if Rails.env.development?
    render(json: response, status: status)
  end
end
