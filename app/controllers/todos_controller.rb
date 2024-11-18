class TodosController < ApplicationController
  def index
    service = Todos::Index.new(params: params, current_user: current_user).perform
    render json: {
      total_count: service[:total_count],
      current_page: service[:current_page],
      todos: TodosPrint.render_as_hash(service[:todos])
    }
  end

  def show
    service = Todos::Show.new(params).perform
    render json: TodosPrint.render(service[:todo])
  end

  def create
    service = Todos::Create.new(params: create_params, current_user: current_user).perform
    if service.success?
      render json: TodosPrint.render(service.todo), status: :created
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  def update
    service = Todos::Update.new(params: update_params, current_user: current_user).perform
    if service.success?
      render json: TodosPrint.render(service.todo)
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    service = Todos::Destroy.new(params: params, current_user: current_user).perform
    if service.success?
      head :no_content
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.permit(:name, :description, :status, :priority, :due_date)
  end

  def update_params
    params.permit(:id, :name, :description, :status, :priority, :due_date)
  end
end
