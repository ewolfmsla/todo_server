defmodule Todo.Cache do
  @moduledoc """
  to do server cache
  """
  use GenServer

  def start_link(_) do
    IO.puts("starting cache")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def server_process(todo_list_name) do
    GenServer.call(__MODULE__, {:server_process, todo_list_name})
  end

  @impl GenServer
  def init(_) do
    Todo.Database.start()
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_process, todo_list_name}, _caller, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}

      :error ->
        {:ok, todo_server} = TodoServer.start(todo_list_name)
        {:reply, todo_server, Map.put(todo_servers, todo_list_name, todo_server)}
    end
  end
end
