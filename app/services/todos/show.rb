module Todos
  class Show
    def initialize(params:, current_user:)
      @params = params
      @current_user = current_user
    end

    def perform
      todo = Todo.where(user_id: @current_user.id).find_by(id: @params[:id])
      { todo: todo }
    rescue ActiveRecord::RecordNotFound => e
      { errors: e.message }
    end
  end
end
