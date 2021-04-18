defmodule GameoflifeTest do
  use ExUnit.Case
  doctest Gameoflife

  test "greets the world" do
    assert Gameoflife.hello() == :world
  end
end
