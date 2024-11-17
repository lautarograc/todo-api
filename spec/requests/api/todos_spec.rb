RSpec.describe 'Todos API', type: :request do
  path '/todos' do
    get 'List Todos' do
      tags 'Todos'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :q, in: :query, schema: { type: :object }, description: 'Ransack query parameters'

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
          create_list(:todo, 3)
        end

        run_test!
      end
    end

    post 'Create a Todo' do
      tags 'Todos'
      consumes 'application/json'
      parameter name: :todo, in: :body, schema: { '$ref' => '#/components/schemas/todo_input' }
      security [ Bearer: {} ]

      response '201', 'Todo created' do
        let(:todo) { { name: 'Test Todo', token: '12345' } }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:todo) { { name: '' } }
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
        let(:id) { create(:todo).id }
        run_test!
      end

      response '404', 'Todo not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Update a Todo' do
      tags 'Todos'
      consumes 'application/json'
      parameter name: :todo, in: :body, schema: { '$ref' => '#/components/schemas/todo_input' }
      security [ Bearer: [] ]

      response '200', 'Todo updated' do
        let(:id) { create(:todo).id }
        let(:todo) { { name: 'Updated Todo' } }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:id) { create(:todo).id }
        let(:todo) { { name: '' } }
        run_test!
      end
    end

    delete 'Delete a Todo' do
      tags 'Todos'
      security [ Bearer: [] ]

      response '204', 'Todo deleted' do
        let(:id) { create(:todo).id }
        run_test!
      end

      response '404', 'Todo not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
