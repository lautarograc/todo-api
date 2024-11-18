require 'rails_helper'

RSpec.describe DatabaseNotificationStrategy do
  describe '#notify_due_date' do
    let(:todo) { create(:todo) }
    let(:strategy) { described_class.new }
    let(:notification_service) { instance_double(NotificationService) }

    before do
      allow(NotificationService).to receive(:new).and_return(notification_service)
      allow(notification_service).to receive(:create_due_date_notification)
    end

    it 'delegates to notification service' do
      strategy.notify_due_date(todo)
      expect(notification_service).to have_received(:create_due_date_notification).with(todo)
    end
  end
end
