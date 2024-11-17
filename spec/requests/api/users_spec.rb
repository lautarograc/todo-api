require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/users/sign_up' do
    post 'Sign up a new user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email_address: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' },
          password_confirmation: { type: :string, example: 'password123' }
        },
        required: ['email_address', 'password', 'password_confirmation']
      }

      response '201', 'User created' do
        let(:user) do
          {
            email_address: 'user@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          }
        end
        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:user) do
          {
            email_address: 'user@example.com',
            password: 'password123',
            password_confirmation: 'wrongpassword'
          }
        end
        run_test!
      end
    end
  end
end
