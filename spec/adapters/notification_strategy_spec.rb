require 'rails_helper'

RSpec.describe NotificationStrategy do
  describe '#notify_due_date' do
    let(:strategy) { NotificationStrategy.new }

    it 'raises NotImplementedError when called' do
      expect { strategy.notify_due_date(double('todo')) }
        .to raise_error(NotImplementedError, /NotificationStrategy must implement #notify_due_date/)
    end
  end
end
