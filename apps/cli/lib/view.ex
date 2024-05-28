defmodule Cli.View do
  def describe({space, _player}) do
    """
    \n#{space.name}
    ----------
    #{Map.keys(space.occupants) |> Enum.join(", ")}
    """
  end
end
