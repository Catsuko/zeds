defmodule Cli do
  def start do
    IO.gets("What is your name?\n")
    |> String.trim()
    |> World.wake_up()
    |> render()
  end

  defp render(state) do
    Cli.View.describe(state) |> IO.puts()
    run(state)
  end

  defp run(state) do
    IO.gets("")
    |> parse_command()
    |> Cli.Commands.execute(state)
    |> render()
  end

  defp parse_command(input) do
    String.split(input, ":")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(fn str -> str == "" end)
  end
end
