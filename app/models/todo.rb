class Todo < ApplicationRecord
  include Tokenable
  acts_as_nested_set

  validates :name, presence: true
end
