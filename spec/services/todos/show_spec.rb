require 'rails_helper'

RSpec.describe Todos::Show, type: :service do
  describe '#perform' do
    let(:current_user) { create(:user) } # Assuming FactoryBot is used for creating test data

    context 'when the todo exists for the current user' do
      let(:todo) { create(:todo, user: current_user) }
      let(:params) { { id: todo.id } }

      it 'returns the todo' do
        service = Todos::Show.new(params: params, current_user: current_user)
        result = service.perform

        expect(result[:todo]).to eq(todo)
        expect(result[:errors]).to be_nil
      end
    end

    context 'when the todo does not exist for the current user' do
      let(:params) { { id: 9999 } } # Non-existent todo ID

      it 'returns nil for the todo' do
        service = Todos::Show.new(params: params, current_user: current_user)
        result = service.perform

        expect(result[:todo]).to be_nil
        expect(result[:errors]).to be_nil
      end
    end

    context 'when the todo exists but belongs to another user' do
      let(:other_user) { create(:user) }
      let(:todo) { create(:todo, user: other_user) }
      let(:params) { { id: todo.id } }

      it 'returns nil for the todo' do
        service = Todos::Show.new(params: params, current_user: current_user)
        result = service.perform

        expect(result[:todo]).to be_nil
        expect(result[:errors]).to be_nil
      end
    end

    context 'when an invalid ID is provided' do
      let(:params) { { id: 'invalid_id' } }

      it 'rescues ActiveRecord::RecordNotFound and returns an error message' do
        service = Todos::Show.new(params: params, current_user: current_user)
        result = service.perform

        expect(result[:todo]).to be_nil
      end
    end
  end
end
