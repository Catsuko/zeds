defmodule World do
  use Application
  use GenServer

  alias World.Agent
  alias World.Space

  @server_name {:global, __MODULE__}

  def start(_start_type, area_names) do
    start_link(area_names)
  end

  def start_link(area_names) do
    GenServer.start_link(__MODULE__, area_names, name: @server_name)
  end

  def init(area_names) do
    {:ok, Space.build(area_names)}
  end

  def new_player(name) do
    GenServer.call(@server_name, {:new_player, name})
  end

  def look_around(area_name) do
    GenServer.call(@server_name, {:look_around, area_name})
  end

  def move(agent_name, from_name, to_name) do
    GenServer.call(@server_name, {:move, agent_name, from_name, to_name})
  end

  def handle_call({:new_player, name}, _from, world) do
    player = %Agent{name: name}
    spawn_name = Enum.random(Map.keys(world))
    spawn = Space.enter(Map.get(world, spawn_name), player)
    log("#{name} woke up in #{spawn_name}.")
    {:reply, {spawn, player}, Map.replace(world, spawn_name, spawn)}
  end

  def handle_call({:look_around, area_name}, _from, world) do
    {:reply, Map.get(world, area_name), world}
  end

  def handle_call({:move, agent_name, from_name, to_name}, _from, world) do
    from = Map.get(world, from_name)
    to = Map.get(world, to_name)
    agent = Space.find_agent(from, agent_name)
    {from, to} = Space.move(from, to, agent)
    log("#{agent.name} moved to #{to_name} from #{from_name}.")
    {:reply, {to, agent}, world |> Map.replace(from.name, from) |> Map.replace(to.name, to)}
  end

  defp log(event) do
    timestamp = DateTime.utc_now() |> DateTime.to_time() |> Time.to_iso8601()
    IO.puts "#{timestamp}: #{event}"
  end
end
