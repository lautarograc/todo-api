module Todos
  class Create
    attr_reader :todo, :errors

    def initialize(params:)
      @params = params
    end

    def perform
      @todo = Todo.new(@params.merge(user_id: 1))
      if @todo.save
        OpenStruct.new(success?: true, todo: @todo)
      else
        OpenStruct.new(success?: false, errors: @todo.errors.full_messages)
      end
    end
  end
end
