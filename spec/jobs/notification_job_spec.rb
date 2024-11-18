require 'rails_helper'

RSpec.describe NotificationJob do
  describe '#perform' do
    let(:todo) { create(:todo) }
    let(:notification_adapter) { instance_double(NotificationAdapter) }

    before do
      allow(Todo).to receive(:find).with(todo.id).and_return(todo)
      allow(NotificationAdapter).to receive(:new).and_return(notification_adapter)
      allow(notification_adapter).to receive(:notify_due_date)
    end

    it 'delegates to notification adapter' do
      described_class.new.perform(todo.id)
      expect(notification_adapter).to have_received(:notify_due_date).with(todo)
    end
  end
end
