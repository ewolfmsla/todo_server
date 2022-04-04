defmodule TodoServer do
  @moduledoc """
  gen server powered to do server
  """

  use GenServer

  alias Todo.List, as: TodoList

  # client

  @spec start(any) :: :ignore | {:error, any} | {:ok, pid}
  def start(name) do
    GenServer.start_link(__MODULE__, name)
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add_entry, entry})
  end

  def get_by_id(pid, id) do
    GenServer.call(pid, {:get_by_id, id})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end

  @spec all(pid()) :: any()
  def all(pid) when is_pid(pid), do: GenServer.call(pid, :all)
  def all(key), do: {:error, "invalid pid: #{inspect(key)}"}

  # server

  @impl true
  def init(name) do
    todos =
      case datastore().get(name) do
        %Todo.List{} = todos ->
          Map.values(todos.entries)

        _ ->
          []
      end

    {:ok, %{name: name, todos: TodoList.new(todos)}}
  end

  @impl true
  def handle_call({:get_by_id, id}, _from, state) do
    {:reply, TodoList.get_todo(state.todos, id), state}
  end

  @impl true
  def handle_call(:all, _from, state) do
    {:reply, Map.values(state.todos.entries), state}
  end

  @impl true
  def handle_call({:entries, date}, _from, state) do
    {:reply, TodoList.entries(state.todos, date), state}
  end

  @impl true
  def handle_cast({:add_entry, entry}, state) do
    todo_list = TodoList.add_new(state.todos, entry)
    datastore().save(state.name, todo_list)
    {:noreply, %{state | todos: todo_list}}
  end

  defp datastore() do
    Application.get_env(:todo_server, :database, Todo.DatabaseBehavior)
  end
end
