defmodule Todo.Item do
  @moduledoc """
  Defines a struct representing a todo item

  defstruct date: nil, id: nil, title: nil
  """
  defstruct date: nil, id: nil, title: nil

  alias Todo.Item, as: TodoItem

  @type todo_item() :: %TodoItem{date: Date.t(), id: integer(), title: String.t()}
end
