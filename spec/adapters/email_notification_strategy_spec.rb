require 'rails_helper'

RSpec.describe EmailNotificationStrategy do
  describe '#notify_due_date' do
    let(:todo) { create(:todo) }
    let(:strategy) { described_class.new }

    it 'sends email notification' do
      expect { strategy.notify_due_date(todo) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
