defmodule World.AgentLocation do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: {:global, __MODULE__})
  end

  def init(index) do
    {:ok, index}
  end

  def locate(agent_name) do
    GenServer.call({:global, __MODULE__}, {:locate, agent_name})
  end

  def update(%World.Agent{name: name}, %World.Space{name: location}) do
    update(name, location)
  end

  def update(agent_name, location) do
    GenServer.call({:global, __MODULE__}, {:update, agent_name, location})
  end

  def handle_call({:locate, agent_name}, _from, index) do
    {:reply, Map.get(index, agent_name, :not_found), index}
  end

  def handle_call({:update, agent_name, location}, _from, index) do
    {:reply, :ok, Map.put(index, agent_name, location)}
  end
end
