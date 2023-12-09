defmodule Day9 do
  @moduledoc """
  Documentation for `Day9`.
  """

  # problem = 1 or 2
  def sum(problem) do
    read_file()
    |> parse_string()
    |> Enum.map(fn row ->
      recursive_row(row, problem)
    end)
    |> Enum.reduce(0, fn row, acc ->
      if problem == 1, do: acc + Enum.at(row, -1), else: acc + Enum.at(row, 0)
    end)
  end

  defp recursive_row(row, problem) when problem == 1 do
    if Enum.all?(row, fn x -> x == 0 end) do
      Enum.concat(row, [0])
    else
      next_row = pair_diffs(row)
      Enum.concat(row, [Enum.at(row, -1) + Enum.at(recursive_row(next_row, problem), -1)])
    end
  end

  defp recursive_row(row, problem) do
    if Enum.all?(row, fn x -> x == 0 end) do
      Enum.concat([0], row)
    else
      next_row = pair_diffs(row)
      Enum.concat([Enum.at(row, 0) - Enum.at(recursive_row(next_row, problem), 0)], row)
    end
  end

  defp pair_diffs(row) do
    Enum.map(Enum.zip(row, Enum.drop(row, 1)), fn {x, y} -> y - x end)
  end

  defp parse_string(string) do
    string
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(" ")
      |> Enum.filter(fn x -> x != "" end)
      |> Enum.map(fn s -> String.to_integer(s) end)
    end)
  end

  defp read_file() do
    File.read!("/Users/madlener/git/AOC23/2023/day9/lib/input-9.txt")
  end
end
