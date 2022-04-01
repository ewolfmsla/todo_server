defmodule Park do
  @moduledoc """
  yellowstone park
  """

  def start() do
    impl().howl("howl!")
  end

  defp impl(), do: Application.get_env(:todo_server, :wolf, WolfBehavior)
end
