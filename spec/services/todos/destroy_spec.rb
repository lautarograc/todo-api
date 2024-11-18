require 'rails_helper'

RSpec.describe Todos::Destroy, type: :service do
  describe '#perform' do
    let(:current_user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:todo) { create(:todo, user: current_user) }

    context 'when the todo exists and belongs to the current user' do
      let(:params) { { id: todo.id } }

      it 'destroys the todo and returns success' do
        service = Todos::Destroy.new(params: params, current_user: current_user)
        result = service.perform

        expect(result.success?).to be true
        expect(Todo.find_by(id: todo.id)).to be_nil
      end
    end

    context 'when the todo does not exist' do
      let(:params) { { id: 9999 } } # Non-existent ID

      it 'returns an error message' do
        service = Todos::Destroy.new(params: params, current_user: current_user)
        result = service.perform

        expect(result.success?).to be false
      end
    end

    context 'when the todo belongs to another user' do
      let!(:todo) { create(:todo, user: other_user) }
      let(:params) { { id: todo.id } }

      it 'returns an error without deleting the todo' do
        service = Todos::Destroy.new(params: params, current_user: current_user)
        result = service.perform

        expect(result.success?).to be false
        expect(Todo.find_by(id: todo.id)).to eq(todo)
      end
    end

    context 'when the todo cannot be destroyed due to validation or callbacks' do
      let(:params) { { id: todo.id } }

      before do
        allow_any_instance_of(Todo).to receive(:destroy).and_return(false)
        allow_any_instance_of(Todo).to receive_message_chain(:errors, :full_messages).and_return(['Cannot delete todo'])
      end

      it 'returns failure with errors' do
        service = Todos::Destroy.new(params: params, current_user: current_user)
        result = service.perform

        expect(result.success?).to be false
        expect(result.errors).to include('Cannot delete todo')
        expect(Todo.find_by(id: todo.id)).to eq(todo) # Ensure the todo was not deleted
      end
    end
  end
end
