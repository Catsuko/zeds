defmodule World do
  use Application

  alias World.BlockSupervisor
  alias World.AgentLocation

  def start(_start_type, area_names) do
    children = [
      {BlockSupervisor, area_names},
      AgentLocation
    ]
    :observer.start()
    Supervisor.start_link(children, strategy: :one_for_all)
  end

  def wake_up(name) do
    agent = %World.Agent{name: name}
    case AgentLocation.locate(name) do
      :not_found -> enter(BlockSupervisor.random(), agent)
      location   -> {agent, look_around(location)}
    end
  end

  defdelegate enter(location , agent), to: World.SpaceServer
  defdelegate move(location, agent, next_location), to: World.SpaceServer
  defdelegate look_around(location), to: World.SpaceServer
end
