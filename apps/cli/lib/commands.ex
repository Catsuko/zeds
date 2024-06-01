defmodule Cli.Commands do
  def execute(["move", next_area_name], {player, area}) do
    World.move(area.name, player, next_area_name)
  end

  def execute(["look around"], {player, area}) do
    {player, World.look_around(area.name)}
  end
end
