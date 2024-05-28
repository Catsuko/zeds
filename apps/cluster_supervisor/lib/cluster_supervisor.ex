defmodule ClusterSupervisor do
  use Application

  def start(_start_type, _start_args) do
    topologies = [
      local: [
        strategy: Cluster.Strategy.LocalEpmd
      ]
    ]
    children = [
      {Cluster.Supervisor, [topologies, [name: Zeds.ClusterSupervisor]]},
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
