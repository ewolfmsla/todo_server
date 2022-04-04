defmodule Todo.Database do
  @moduledoc """
  file database implementation
  """

  use GenServer

  @behaviour Todo.DatabaseBehavior

  @db_folder "./dbstore"

  @impl true
  def start() do
    IO.puts("starting database")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def save(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.save(key, data)
  end

  @impl true
  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  # Choosing a worker makes a request to the database server process. There we
  # keep the knowledge about our workers, and return the pid of the corresponding
  # worker. Once this is done, the caller process will talk to the worker directly.
  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, start_workers()}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _, workers) do
    worker_key = :erlang.phash2(key, 3)
    {:reply, Map.get(workers, worker_key), workers}
  end

  defp start_workers() do
    for index <- 1..3, into: %{} do
      IO.puts("starting database worker #{index - 1}")
      {:ok, pid} = Todo.DatabaseWorker.start(@db_folder)
      {index - 1, pid}
    end
  end
end
