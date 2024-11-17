class Todo < ApplicationRecord
  include Tokenable

  validates :name, presence: true

  belongs_to :parent, class_name: "Todo", optional: true
  has_many :children, class_name: "Todo", foreign_key: "parent_id", dependent: :destroy

  before_create :set_nested_set_values
  before_update :update_nested_set_values, if: :parent_id_changed?

  def set_nested_set_values
    if parent
      self.lft = parent.rgt
      self.rgt = parent.rgt + 1
      parent.increment_nested_set_values(2)
    else
      max_rgt = Todo.maximum(:rgt) || 0
      self.lft = max_rgt + 1
      self.rgt = max_rgt + 2
    end
  end

  def increment_nested_set_values(value)
    Todo.where("rgt >= ?", self.rgt).update_all("rgt = rgt + ?", value)
    Todo.where("lft > ?", self.rgt).update_all("lft = lft + ?", value)
  end

  def update_nested_set_values
    old_parent = Todo.find(parent_id_was)
    old_parent.decrement_nested_set_values(2)
    set_nested_set_values
  end

  def ancestors
    Todo.where("lft < ? AND rgt > ?", lft, rgt)
  end

  def descendants
    Todo.where("lft > ? AND rgt < ?", lft, rgt)
  end

  def siblings
    parent ? parent.children.where.not(id: id) : Todo.where(parent_id: nil).where.not(id: id)
  end
end
