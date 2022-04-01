defmodule Todo.CacheTest do
  @moduledoc """
  tests the cache service
  """

  use ExUnit.Case, async: false

  import Mox

  setup [:set_mox_from_context, :verify_on_exit!]

  alias Todo.Item, as: TodoItem

  @entry_date ~D[2022-03-23]

  test "server_process/2" do
    DatabaseMock
    |> expect(:get, 2, fn _ -> [] end)

    {:ok, pid} = Todo.Cache.start()

    foo_pid = Todo.Cache.server_process(pid, :foo)
    bar_pid = Todo.Cache.server_process(pid, :bar)

    assert foo_pid != bar_pid
  end

  test "ref test - from testing elixir book" do
    ref = make_ref()
    send(self(), {:hello, ref})

    assert_receive({:hello, ^ref}, 5_00)
  end

  test "ensure pid returned by cache works with to do server" do
    DatabaseMock
    |> expect(:get, 2, fn _ -> [] end)

    {:ok, pid} = Todo.Cache.start()

    foo_pid = Todo.Cache.server_process(pid, :foo)
    bar_pid = Todo.Cache.server_process(pid, :bar)

    DatabaseMock
    |> expect(:save, 2, fn key, term ->
      assert key in [:foo, :bar]

      case key do
        :foo ->
          assert %Todo.List{
                   auto_id: 2,
                   entries: %{1 => %Todo.Item{date: ~D[2022-03-23], id: 1, title: "foo title"}}
                 } = term

        :bar ->
          assert %Todo.List{
                   auto_id: 2,
                   entries: %{
                     1 => %Todo.Item{date: ~D[2022-03-23], id: 1, title: "bar title"}
                   }
                 } = term

        _ ->
          throw({:error, "no key found for #{key}"})
      end

      :ok
    end)

    TodoServer.add_entry(foo_pid, build_entry("foo title"))
    TodoServer.add_entry(bar_pid, build_entry("bar title"))

    assert [%Todo.Item{date: ~D[2022-03-23], id: 1, title: "foo title"}] = TodoServer.all(foo_pid)
    assert [%Todo.Item{date: ~D[2022-03-23], id: 1, title: "bar title"}] = TodoServer.all(bar_pid)
  end

  defp build_entry(date \\ @entry_date, title), do: %TodoItem{date: date, title: title}
end
