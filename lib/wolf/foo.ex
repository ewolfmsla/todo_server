defmodule Foo do
  @moduledoc """
  this is a test module
  """

  def bar() do
    {:ok, Enum.reduce(1..4, 0, fn x, acc -> x + acc end)}
  end
end
