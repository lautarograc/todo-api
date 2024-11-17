module Todos
  class Index
    def initialize(params)
      @params = params
    end

    def perform
      q = Todo.ransack(@params[:q])
      todos = q.result.order(created_at: :desc)

      page = @params[:page].to_i > 0 ? @params[:page].to_i : 1
      per_page = 10
      total_count = todos.count
      todos = todos.offset((page - 1) * per_page).limit(per_page)

      { todos: todos, total_count: total_count, current_page: page }
    end
  end
end
