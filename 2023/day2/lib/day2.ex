defmodule Day2 do
  @moduledoc """
  Documentation for `Day2`.
  """
  @red_cube_limit 12
  @green_cube_limit 13
  @blue_cube_limit 14

  def id_sum() do
    read_file()
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&filter/1)
    |> Enum.map(fn %{id: id, blue: _, green: _, red: _} -> id end)
    |> Enum.sum()
  end

  def power_sum() do
    read_file()
    |> Enum.map(&parse_line/1)
    |> Enum.map(&power/1)
    |> Enum.sum()
  end

  defp power(%{blue: blue, green: green, red: red}) do
    blue * green * red
  end

  defp filter(%{blue: blue, green: green, red: red}) do
    blue <= @blue_cube_limit && green <= @green_cube_limit && red <= @red_cube_limit
  end

  defp parse_line(string) do
    # Game 1: 12 blue; 2 green, 13 blue, 19 red; 13 red, 3 green, 14 blue
    id =
      string
      |> String.split(": ")
      |> Enum.at(0)
      |> String.split(" ")
      |> Enum.at(1)
      |> String.to_integer()

    list =
      string
      |> String.replace(~r/Game \d+: /, "")
      |> String.split(~r/,\s|;\s/)

    max_blue = list |> max_value("blue")
    max_green = list |> max_value("green")
    max_red = list |> max_value("red")

    %{id: id, blue: max_blue, green: max_green, red: max_red}
  end

  defp max_value(list, color) do
    list
    |> Enum.filter(fn x -> String.contains?(x, color) end)
    |> Enum.map(fn x -> String.split(x, " ") |> Enum.at(0) |> String.to_integer() end)
    |> Enum.max()
  end

  defp read_file() do
    File.read!("/Users/madlener/git/AOC23/2023/day2/lib/input-2.txt")
    |> String.split("\n")
  end
end
