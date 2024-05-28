defmodule ClusterSupervisorTest do
  use ExUnit.Case
  doctest ClusterSupervisor

  test "greets the world" do
    assert ClusterSupervisor.hello() == :world
  end
end
