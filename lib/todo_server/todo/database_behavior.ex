defmodule Todo.DatabaseBehavior do
  @moduledoc """
  behaviors defined for database actions
  """

  alias Todo.Item, as: TodoItem

  @callback start() :: {:ok, pid()}
  @callback save(String.t() | atom(), TodoItem.todo_item()) :: atom()
  @callback get(String.t() | atom()) :: list(TodoItem.todo_item())
end
