class Todo < ApplicationRecord
  include Tokenable
  acts_as_nested_set

  enum :status, %i[pending in_progress completed]
  enum :priority, %i[low medium high]

  ransacker :status, formatter: proc { |v| statuses[v] } do |parent|
    parent.table[:status]
  end

  ransacker :priority, formatter: proc { |v| priorities[v] } do |parent|
    parent.table[:priority]
  end

  validates :name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[name created_at status priority due_date]
  end
end
