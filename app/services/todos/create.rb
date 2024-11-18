module Todos
  class Create
    attr_reader :todo, :errors

    def initialize(params:, current_user:)
      @params = params
      @current_user = current_user
    end

    def perform
      @todo = Todo.new(@params.merge(user_id: @current_user.id))
      if @todo.save
        OpenStruct.new(success?: true, todo: @todo)
      else
        OpenStruct.new(success?: false, errors: @todo.errors.full_messages)
      end
    end
  end
end
