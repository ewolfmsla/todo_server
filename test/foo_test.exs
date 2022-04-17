defmodule FooTest do
  use ExUnit.Case, async: false


  test "bar/1`" do
  	assert {:ok, 10} = Foo.bar()
  end
end
