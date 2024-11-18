module Todos
  class Index
    def initialize(params:, current_user:)
      @params = params
      @current_user = current_user
    end

    def perform
      q = Todo.where(user_id: @current_user.id, parent_id: nil).includes(:parent, :children).ransack(@params[:q])
      todos = q.result.order(created_at: :desc)

      page = @params[:page].to_i > 0 ? @params[:page].to_i : 1
      per_page = 10
      total_count = todos.count
      todos = todos.offset((page - 1) * per_page).limit(per_page)

      { todos: todos, total_count: total_count, current_page: page }
    end
  end
end
