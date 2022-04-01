defmodule Todo.Database do
  @moduledoc """
  file database implementation
  """

  use GenServer

  @behaviour Todo.DatabaseBehavior

  @db_folder "./dbstore"

  @impl true
  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def save(key, term) do
    GenServer.cast(__MODULE__, {:save, key, term})
  end

  @impl true
  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, nil}
  end

  @impl GenServer
  def handle_cast({:save, key, term}, state) do
    key
    |> file_name()
    |> File.write!(:erlang.term_to_binary(term))

    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:get, key}, _caller, state) do
    data =
      case File.read(file_name(key)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        {:error, _} -> []
      end

    {:reply, data, state}
  end

  defp file_name(key), do: Path.join(@db_folder, Atom.to_string(key))
end
