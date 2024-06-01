defmodule Cli.View do
  def describe({_player, space}) do
    """
    \n#{space.name}
    ----------
    #{Map.keys(space.occupants) |> Enum.join(", ")}
    """
  end
end
