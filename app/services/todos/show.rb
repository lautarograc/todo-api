module Todos
  class Show
    def initialize(params)
      @id = params[:id]
    end

    def perform
      todo = Todo.find(@id)
      { todo: todo }
    rescue ActiveRecord::RecordNotFound => e
      { errors: e.message }
    end
  end
end
