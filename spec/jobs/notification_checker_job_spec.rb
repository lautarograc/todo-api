require 'rails_helper'

RSpec.describe NotificationCheckerJob do
  describe '#perform' do
    let!(:todo_due_tomorrow) { create(:todo, due_date: Date.tomorrow) }
    let!(:todo_due_today) { create(:todo, due_date: Date.today) }

    it 'enqueues notification worker for todos due tomorrow' do
      expect(NotificationJob).to receive(:perform_later).with(todo_due_tomorrow.id)
      expect(NotificationJob).not_to receive(:perform_later).with(todo_due_today.id)

      described_class.new.perform
    end
  end
end
