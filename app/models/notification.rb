class Notification < ApplicationRecord
  belongs_to :todo
  validates :notification_type, presence: true
  validates :sent_at, presence: true
end
