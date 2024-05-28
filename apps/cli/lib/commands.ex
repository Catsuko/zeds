defmodule Cli.Commands do
  def execute(["move", next_area_name], {area, player}) do
    World.move(player.name, area.name, next_area_name)
  end

  def execute(["look around"], {area, player}) do
    {World.look_around(area.name), player}
  end
end
