require 'swagger_helper'

RSpec.describe 'Todos API', type: :request, openapi_spec: 'v1/swagger.yaml' do
  before(:each) do
    auth_headers
  end

  path '/todos' do
    get 'List Todos' do
      tags 'Todos'
      produces 'application/json'
      security [ Bearer: [] ]

      response '200', 'Todos retrieved' do
        schema type: :object,
               properties: {
                 total_count: { type: :integer },
                 current_page: { type: :integer },
                 todos: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/todo' }
                 }
               },
               required: %w[total_count current_page todos]

        before do
          create_list(:todo, 10, user: current_user)
        end

        let(:Authorization) { auth_headers['Authorization'] }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end

    post 'Create a Todo' do
      tags 'Todos'
      consumes 'application/json'
      parameter name: :todo, in: :body, schema: { '$ref' => '#/components/schemas/todo_input' }
      security [ Bearer: [] ]

      response '201', 'Todo created' do
        let(:todo) { { name: 'Test Todo', token: '12345' } }
        let(:Authorization) { auth_headers['Authorization'] }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:todo) { { name: '' } }
        let(:Authorization) { auth_headers['Authorization'] }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:todo) { { name: 'Test Todo' } }
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end
  end

  path '/todos/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Todo ID'

    get 'Retrieve a Todo' do
      tags 'Todos'
      produces 'application/json'
      security [ Bearer: [] ]


      response '200', 'Todo found' do
        schema '$ref' => '#/components/schemas/todo'
        let(:id) { create(:todo, user: current_user).id }
        let(:Authorization) { auth_headers['Authorization'] }
        run_test!
      end

      response '404', 'Todo not found' do
        let(:id) { 'invalid' }
        let(:Authorization) { auth_headers['Authorization'] }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { create(:todo, user: @current_user).id }
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end

    put 'Update a Todo' do
      tags 'Todos'
      consumes 'application/json'
      parameter name: :todo, in: :body, schema: { '$ref' => '#/components/schemas/todo_input' }
      security [ Bearer: [] ]

      response '200', 'Todo updated' do
        let(:id) { create(:todo, user: @current_user).id }
        let(:todo) { { name: 'Updated Todo' } }
        let(:Authorization) { auth_headers['Authorization'] }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:id) { create(:todo, user: @current_user).id }
        let(:todo) { { name: '' } }
        let(:Authorization) { auth_headers['Authorization'] }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { create(:todo, user: @current_user).id }
        let(:todo) { { name: 'Updated Todo' } }
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end

    delete 'Delete a Todo' do
      tags 'Todos'
      security [ Bearer: [] ]

      response '204', 'Todo deleted' do
        let(:id) { create(:todo, user: @current_user).id }
        let(:Authorization) { auth_headers['Authorization'] }
        run_test!
      end

      response '422', 'Unprocessable' do
        let(:id) { 'invalid' }
        let(:Authorization) { auth_headers['Authorization'] }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:id) { create(:todo, user: @current_user).id }
        let(:Authorization) { 'Bearer invalid_token' }
        run_test!
      end
    end
  end
end
