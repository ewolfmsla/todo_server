alias Todo.Item, as: TodoItem
alias Todo.List, as: TodoList
alias TodoServer, as: Server
alias Todo.Cache, as: Cache

defmodule Util do
  def entry(date \\ ~D[2022-03-23], title), do: %TodoItem{date: date, title: title}
end

{:ok, pid} = Cache.start()

sally = Cache.server_process(pid, :sally)
eric = Cache.server_process(pid, :eric)
