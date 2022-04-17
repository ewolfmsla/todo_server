defmodule Todo.DatabaseBehavior do
  @moduledoc """
  behaviors defined for database actions
  """

  alias Todo.Item, as: TodoItem

  @callback start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  @callback save(String.t() | atom(), TodoItem.todo_item()) :: atom()
  @callback get(String.t() | atom()) :: list(TodoItem.todo_item())
end
