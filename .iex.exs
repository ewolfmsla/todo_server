alias Todo.Item, as: TodoItem
alias Todo.List, as: TodoList
alias TodoServer, as: Server
alias Todo.Cache, as: Cache

defmodule Util do
  def entry(date \\ ~D[2022-03-23], title), do: %TodoItem{date: date, title: title}
  def reg() do
    spawn(fn ->
      Registry.register(:wolf_reg, {:foo_worker, 1}, nil)

      receive do
        msg -> IO.puts("got message #{inspect(msg)}")
      end

    end)
  end
end

# {:ok, pid} = Cache.start()

Registry.start_link(name: :wolf_reg, keys: :unique)

# sally = Cache.server_process(pid, :sally)
# eric = Cache.server_process(pid, :eric)
