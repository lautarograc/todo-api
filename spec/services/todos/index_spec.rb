require 'rails_helper'

RSpec.describe Todos::Index, type: :service do
  describe '#perform' do
    let(:current_user) { create(:user) }
    let(:other_user) { create(:user) }

    before do
      create_list(:todo, 15, user: current_user, parent_id: nil)

      create_list(:todo, 5, user: other_user, parent_id: nil)
    end

    context 'when fetching todos for the current user' do
      let(:params) { { page: 1, q: {} } }

      it 'returns the first page of todos with a default limit' do
        service = Todos::Index.new(params: params, current_user: current_user)
        result = service.perform

        expect(result[:todos].size).to eq(10)
        expect(result[:total_count]).to eq(15)
        expect(result[:current_page]).to eq(1)
      end
    end

    context 'when fetching the second page of todos' do
      let(:params) { { page: 2, q: {} } }

      it 'returns the second page of todos' do
        service = Todos::Index.new(params: params, current_user: current_user)
        result = service.perform

        expect(result[:todos].size).to eq(5)
        expect(result[:total_count]).to eq(15)
        expect(result[:current_page]).to eq(2)
      end
    end

    context 'when no page parameter is provided' do
      let(:params) { { q: {} } }

      it 'defaults to the first page' do
        service = Todos::Index.new(params: params, current_user: current_user)
        result = service.perform

        expect(result[:current_page]).to eq(1)
        expect(result[:todos].size).to eq(10)
      end
    end

    context 'when applying search filters' do
      let!(:matching_todo) { create(:todo, user: current_user, name: 'Important Task', parent_id: nil) }
      let(:params) { { q: { name_cont: 'Important' }, page: 1 } }

      it 'returns todos that match the search query' do
        service = Todos::Index.new(params: params, current_user: current_user)
        result = service.perform

        expect(result[:todos]).to include(matching_todo)
        expect(result[:todos].size).to eq(1)
        expect(result[:total_count]).to eq(1)
      end
    end

    context 'when the user has no todos' do
      let(:params) { { page: 1, q: {} } }
      let(:empty_user) { create(:user) }

      it 'returns an empty result set' do
        service = Todos::Index.new(params: params, current_user: empty_user)
        result = service.perform

        expect(result[:todos]).to be_empty
        expect(result[:total_count]).to eq(0)
        expect(result[:current_page]).to eq(1)
      end
    end
  end
end
