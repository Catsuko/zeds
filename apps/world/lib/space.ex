defmodule World.Space do
  alias World.Space
  alias World.Agent
  defstruct [:name, exits: MapSet.new, occupants: %{}]

  def move(from, to, agent) do
    {Space.leave(from, agent), Space.enter(to, agent)}
  end

  def enter(space, %Agent{name: name} = occupant) do
    put_in(space.occupants[name], occupant)
  end

  def leave(%Space{occupants: occupants} = space, %Agent{name: name}) do
    %Space{space | occupants: Map.delete(occupants, name)}
  end

  def contains?(%Space{occupants: occupants}, %Agent{name: name}) do
    Map.has_key?(occupants, name)
  end

  def find_agent(%Space{occupants: occupants}, name) do
    Map.get(occupants, name)
  end

  def population(%Space{occupants: occupants}) do
    map_size(occupants)
  end

  def build(names) do
    names
    |> Enum.map(fn name -> %Space{name: name} end)
    |> Map.new(fn area -> {area.name, area} end)
  end
end
