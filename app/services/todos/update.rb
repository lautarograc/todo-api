module Todos
  class Update
    attr_reader :todo, :errors

    def initialize(params:, current_user:)
      @params = params
      @current_user = current_user
    end

    def perform
      @todo = Todo.find_by(id: @params[:id])
      if @todo.update(@params) && @todo.user_id == @current_user.id
        OpenStruct.new(success?: true, todo: @todo)
      else
        OpenStruct.new(success?: false, errors: @todo.errors.full_messages)
      end
    rescue ActiveRecord::RecordNotFound => e
      OpenStruct.new(success?: false, errors: [ e.message ])
    end
  end
end
