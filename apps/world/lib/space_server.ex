defmodule World.SpaceServer do
  use GenServer

  alias World.AgentLocation
  alias World.Agent
  alias World.Space

  def start_link(%Space{name: name} = space) do
    GenServer.start_link(__MODULE__, space, name: {:global, String.to_atom(name)})
  end

  def init(space) do
    {:ok, space}
  end

  def enter(location, %Agent{} = agent) do
    GenServer.call({:global, String.to_existing_atom(location)}, {:enter, agent})
  end

  def move(location, %Agent{} = agent, next_location) do
    GenServer.call({:global, String.to_existing_atom(location)}, {:move, agent, next_location})
  end

  def look_around(location) do
    GenServer.call({:global, String.to_existing_atom(location)}, :look_around)
  end

  def handle_cast({:enter, agent, from}, space) do
    space = add_agent_to_space(agent, space)
    GenServer.reply(from, {agent, space})
    {:noreply, space}
  end

  def handle_call({:enter, agent}, _from, space) do
    space = add_agent_to_space(agent, space)
    {:reply, {agent, space}, space}
  end

  def handle_call({:move, agent, next_location}, from, space) do
    GenServer.cast({:global, String.to_existing_atom(next_location)}, {:enter, agent, from})
    {:noreply, Space.leave(space, agent)}
  end

  def handle_call(:look_around, _from, space) do
    {:reply, space, space}
  end

  defp log(%Space{name: name}, event) do
    timestamp = DateTime.utc_now() |> DateTime.to_time() |> Time.to_iso8601()
    IO.puts "#{timestamp} [#{name}]: #{event}"
  end

  defp add_agent_to_space(agent, space) do
    space = Space.enter(space, agent)
    :ok = AgentLocation.update(agent, space)
    log(space, "#{agent.name} entered")
    space
  end
end
