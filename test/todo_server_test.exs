defmodule TodoServerTest do
  @moduledoc """
  test for the genserver driven to do list
  """

  use ExUnit.Case

  import Mox

  setup [:set_mox_from_context, :verify_on_exit!]

  alias Todo.Item, as: TodoItem

  @entry_date ~D[2022-03-23]

  setup do
    DatabaseMock
    |> expect(:get, fn _ -> [] end)

    {:ok, pid} = TodoServer.start(:server)
    {:ok, pid: pid}
  end

  test "add_entry/1", %{pid: pid} do
    DatabaseMock
    |> expect(:save, 2, fn _key, _term ->
      :ok
    end)

    :ok = TodoServer.add_entry(pid, build_entry("wake up"))
    :ok = TodoServer.add_entry(pid, build_entry("drink coffee"))

    assert 2 == length(TodoServer.entries(pid, @entry_date))

    assert %{
             name: :server,
             todos: %Todo.List{
               auto_id: 3,
               entries: %{
                 1 => %Todo.Item{date: ~D[2022-03-23], id: 1, title: "wake up"},
                 2 => %Todo.Item{date: ~D[2022-03-23], id: 2, title: "drink coffee"}
               }
             }
           } = :sys.get_state(pid)
  end

  test "entries/1", %{pid: pid} do
    DatabaseMock
    |> expect(:save, 3, fn key, term ->
      assert :server == key
      assert %Todo.List{auto_id: _auto_id} = term
      :ok
    end)

    :ok = TodoServer.add_entry(pid, build_entry("wake up"))
    :ok = TodoServer.add_entry(pid, build_entry(~D[2022-03-22], "get dressed"))
    :ok = TodoServer.add_entry(pid, build_entry("drink coffee"))

    assert [%Todo.Item{date: ~D[2022-03-22], id: 2, title: "get dressed"}] =
             TodoServer.entries(pid, ~D[2022-03-22])
  end

  test "all/1 return :error tuple for key not found" do
    assert {:error, reason} = TodoServer.all(:bad_key)
    assert "no todos found for key :bad_key" = reason
  end

  test "get_by_id/1", %{pid: pid} do
    DatabaseMock
    |> expect(:save, 3, fn _, _ ->
      :ok
    end)

    :ok = TodoServer.add_entry(pid, build_entry("wake up"))
    :ok = TodoServer.add_entry(pid, build_entry("drink coffee"))
    :ok = TodoServer.add_entry(pid, build_entry("drink more coffee"))

    %TodoItem{title: title} = TodoServer.get_by_id(pid, 2)
    assert "drink coffee" = title
  end

  defp build_entry(date \\ @entry_date, title), do: %TodoItem{date: date, title: title}
end
