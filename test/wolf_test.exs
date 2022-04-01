defmodule WolfTest do
  @moduledoc """
  wolf test
  """

  use ExUnit.Case, async: true

  import Mox

  setup [:verify_on_exit!]

  test "start/0" do
    # stub(WolfMock, :howl, fn sound ->
    #   assert "howl!" == sound
    #   {:ok, "mock return"}
    # end)

    WolfMock
    |> expect(:howl, fn sound ->
      assert "howl!" == sound
      {:ok, "mock return"}
    end)

    assert {:ok, "mock return"} == Park.start()
  end
end
