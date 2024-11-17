class TodosController < ApplicationController
  def index
    service = Todos::Index.new(params).perform
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
    service = Todos::Create.new(params: create_params).perform
    if service.success?
      render json: TodosPrint.render(service.todo), status: :created
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  def update
    service = Todos::Update.new(params).perform
    if service.success?
      render json: TodosPrint.render(service.todo)
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    service = Todos::Destroy.new(params).perform
    if service.success?
      head :no_content
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  private

  def create_params
    params.permit(:name, :parent_id, :description)
  end
end
