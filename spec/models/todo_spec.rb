require 'rails_helper'

RSpec.describe Todo, type: :model do
  describe 'scopes' do
    let!(:todo_due_tomorrow) { create(:todo, due_date: Date.tomorrow) }
    let!(:todo_due_today) { create(:todo, due_date: Date.today) }

    describe '.due_tomorrow' do
      it 'includes todos with a due_date of tomorrow' do
        expect(Todo.due_tomorrow).to include(todo_due_tomorrow)
      end

      it 'excludes todos not due tomorrow' do
        expect(Todo.due_tomorrow).not_to include(todo_due_today)
      end
    end
  end

  describe 'enums' do
    it 'defines status enum with expected values' do
      expect(Todo.statuses).to eq({ 'pending' => 0, 'in_progress' => 1, 'completed' => 2 })
    end

    it 'defines priority enum with expected values' do
      expect(Todo.priorities).to eq({ 'low' => 0, 'medium' => 1, 'high' => 2 })
    end
  end

  describe 'ransackers' do
    it 'ransacks status correctly' do
      todo = create(:todo, status: 'completed')
      expect(Todo.ransack(status_eq: 'completed').result).to include(todo)
    end

    it 'ransacks priority correctly' do
      todo = create(:todo, priority: 'high')
      expect(Todo.ransack(priority_eq: 'high').result).to include(todo)
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the correct list of attributes' do
      expect(Todo.ransackable_attributes).to match_array(%w[name created_at status priority due_date])
    end
  end

  describe '#notify_due_date' do
    let(:todo) { build(:todo) }
    let(:notification_service) { double(NotificationService) }

    before do
      allow(NotificationService).to receive(:new).and_return(notification_service)
      allow(notification_service).to receive(:create_due_date_notification)
    end

    it 'calls NotificationService to create a due date notification' do
      todo.notify_due_date
      expect(notification_service).to have_received(:create_due_date_notification).with(todo)
    end
  end

  describe 'acts_as_nested_set' do
    let!(:parent) { create(:todo) }
    let!(:child) { create(:todo, parent: parent) }

    it 'allows setting a parent-child relationship' do
      expect(child.parent).to eq(parent)
    end

    it 'retrieves children correctly' do
      expect(parent.children).to include(child)
    end
  end
end
