defmodule World.BlockSupervisor do
  use Supervisor

  alias World.SpaceServer
  alias World.Space

  def start_link(block_names) do
    Supervisor.start_link(__MODULE__, block_names, name: {:global, __MODULE__})
  end

  def init(block_names) do
    children = Enum.map(block_names, fn name -> %Space{name: name} end)
      |> Enum.map(fn block -> Supervisor.child_spec({SpaceServer, block}, id: block.name) end)
    Supervisor.init(children, strategy: :one_for_one)
  end

  def random do
    Supervisor.which_children({:global, __MODULE__})
      |> Enum.map(fn {name, _, _, _} -> name end)
      |> Enum.random()
  end
end
