class TodosPrint < Blueprinter::Base
  identifier :id

  fields :name, :description, :token

  field :children_count do |todo, _options|
    todo.children.count
  end

  field :level_hash do |todo, _options|
    {
      id: todo.id,
      parent: todo.parent_id,
      children: todo.children.map(&:id),
      siblings: todo.siblings.map(&:id)
    }
  end

  field :parent_name do |todo, _options|
    todo.parent&.name
  end

  field :parent_token do |todo, _options|
    todo.parent&.token
  end
end
