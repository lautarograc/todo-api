require 'rails_helper'

RSpec.describe NotificationService do
  describe '#create_due_date_notification' do
    let(:todo) { double('Todo', name: 'Submit Report', notifications: notifications) }
    let(:notifications) { double('ActiveRecord::Relation') }
    let(:notification_service) { described_class.new }

    context 'when notification creation is successful' do
      it 'creates a due date reminder notification for the todo' do
        expect(notifications).to receive(:create!).with(
          notification_type: 'due_date_reminder',
          sent_at: kind_of(Time),
          content: "Task 'Submit Report' is due tomorrow"
        )

        notification_service.create_due_date_notification(todo)
      end
    end
  end
end
