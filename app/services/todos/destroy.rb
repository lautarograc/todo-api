module Todos
  class Destroy
    attr_reader :errors

    def initialize(params)
      @id = params[:id]
    end

    def perform
      todo = Todo.find(@id)
      if todo.destroy
        OpenStruct.new(success?: true)
      else
        OpenStruct.new(success?: false, errors: todo.errors.full_messages)
      end
    rescue ActiveRecord::RecordNotFound => e
      OpenStruct.new(success?: false, errors: [ e.message ])
    end
  end
end
