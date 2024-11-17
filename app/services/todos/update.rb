module Todos
  class Update
    attr_reader :todo, :errors

    def initialize(params)
      @id = params[:id]
      @params = params.require(:todo).permit(:name, :token, :description, :parent_id)
    end

    def perform
      @todo = Todo.find(@id)
      if @todo.update(@params)
        OpenStruct.new(success?: true, todo: @todo)
      else
        OpenStruct.new(success?: false, errors: @todo.errors.full_messages)
      end
    rescue ActiveRecord::RecordNotFound => e
      OpenStruct.new(success?: false, errors: [ e.message ])
    end
  end
end
