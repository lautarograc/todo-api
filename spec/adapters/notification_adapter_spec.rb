require 'rails_helper'

RSpec.describe NotificationAdapter do
  describe '#notify_due_date' do
    let(:todo) { create(:todo) }
    let(:adapter) { described_class.new }
    let(:strategy) { instance_double(DatabaseNotificationStrategy) }

    before do
      allow(DatabaseNotificationStrategy).to receive(:new).and_return(strategy)
      allow(strategy).to receive(:notify_due_date)
    end

    it 'delegates to the notification strategy' do
      adapter.notify_due_date(todo)
      expect(strategy).to have_received(:notify_due_date).with(todo)
    end
  end
end
