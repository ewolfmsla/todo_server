defmodule TodoServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = children()

    opts = [strategy: :one_for_one, name: TodoServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp children() do
    case Application.get_env(:todo_server, :env) do
      :test ->
        []

      _ ->
        [
          {Todo.ProcessRegistry, nil},
          {Todo.Cache, nil},
          {Todo.Database, nil}
        ]
    end
  end
end
