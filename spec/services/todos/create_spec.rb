require 'rails_helper'

RSpec.describe Todos::Create, type: :service do
  describe '#perform' do
    let(:current_user) { create(:user) }

    context 'when the todo is successfully created' do
      let(:params) { { name: 'Test Todo', description: 'This is a test todo.' } }

      it 'returns a success result with the created todo' do
        service = Todos::Create.new(params: params, current_user: current_user)
        result = service.perform

        expect(result.success?).to be true
        expect(result.todo).to be_persisted
        expect(result.todo.name).to eq(params[:name])
        expect(result.todo.description).to eq(params[:description])
        expect(result.todo.user_id).to eq(current_user.id)
      end
    end

    context 'when the todo creation fails' do
      let(:params) { { name: nil, description: 'This is a test todo.' } }

      it 'returns a failure result with errors' do
        service = Todos::Create.new(params: params, current_user: current_user)
        result = service.perform

        expect(result.success?).to be false
        expect(result.errors).to include("Name can't be blank")
      end
    end
  end
end
