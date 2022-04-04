defmodule Todo.DatabaseWorker do
  @moduledoc """
  database worker
  """

  use GenServer

  def start(db_folder) do
    GenServer.start_link(__MODULE__, db_folder)
  end

  def save(worker_pid, key, data) do
    GenServer.cast(worker_pid, {:store, key, data})
  end

  def get(worker_pid, key) do
    GenServer.call(worker_pid, {:get, key})
  end

  @impl GenServer
  def init(db_folder) do
    {:ok, db_folder}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, db_folder) do
    spawn(fn ->
      db_folder
      |> file_name(key)
      |> File.write!(:erlang.term_to_binary(data))
    end)

    {:noreply, db_folder}
  end

  @impl GenServer
  def handle_call({:get, key}, caller, db_folder) do
    spawn(fn ->
      data =
        case File.read(file_name(db_folder, key)) do
          {:ok, contents} -> :erlang.binary_to_term(contents)
          {:error, _} -> []
        end

      GenServer.reply(caller, data)
    end)

    {:noreply, db_folder}

    # data =
    #   case File.read(file_name(db_folder, key)) do
    #     {:ok, contents} -> :erlang.binary_to_term(contents)
    #     _ -> nil
    #   end

    # {:reply, data, db_folder}
  end

  defp file_name(db_folder, key) do
    Path.join(db_folder, to_string(key))
  end
end
