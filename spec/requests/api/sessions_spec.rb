require 'swagger_helper'

RSpec.describe 'Sessions API', type: :request do
  path '/sessions' do
    post 'Create a session (log in)' do
      tags 'Sessions'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email_address: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: ['email_address', 'password']
      }

      response '200', 'Session created' do
        let(:user) do
          User.create(
            email_address: 'user@example.com',
            password: 'password123',
            password_confirmation: 'password123'
          )
        end
        let(:credentials) { { email_address: user.email_address, password: 'password123' } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['data']['token']).to be_present
        end
      end

      response '401', 'Unauthorized' do
        let(:credentials) { { email_address: 'wrong@example.com', password: 'wrongpassword' } }
        run_test!
      end

      response '429', 'Too Many Requests' do
        before do
          10.times do
            post '/sessions', params: { email_address: 'user@example.com', password: 'password123' }
          end
        end
        let(:credentials) { { email_address: 'user@example.com', password: 'password123' } }
        run_test!
      end
    end
  end
end
