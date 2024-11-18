module Todos
  class Destroy
    attr_reader :errors

    def initialize(params:, current_user:)
      @params = params
      @current_user = current_user
    end

    def perform
      todo = Todo.where(user_id: @current_user.id).find(@params[:id])
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
