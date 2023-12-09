defmodule Day8 do
  @moduledoc """
  Documentation for `Day8`.
  """
  import Math

  def steps do
    {lrs, paths} = prepare_data()

    loop(lrs, paths, "AAA", 0)
  end

  def steps_2 do
    {lrs, paths} = prepare_data()

    keys =
      paths
      |> Enum.filter(fn {key, _} -> String.graphemes(key) |> Enum.at(2) == "A" end)
      |> Enum.map(fn {key, _} -> key end)

    nums = keys |> Enum.map(fn key -> loop_2(lrs, paths, key, 0) end)

    nums
    |> Enum.reduce(1, fn num, acc ->
      Math.lcm(num, acc)
    end)
  end

  defp prepare_data do
    {lrs, paths} =
      read_file()
      |> parse_string()
  end

  defp loop(lrs, paths, key, steps) do
    result =
      Enum.reduce(lrs, %{key: key, steps: steps}, fn lr, acc ->
        IO.inspect(acc)

        if acc.key == "ZZZ" do
          acc
        else
          {next_key_l, next_key_r} = Map.get(paths, acc.key)
          next_key = if lr == "L", do: next_key_l, else: next_key_r
          %{key: next_key, steps: acc.steps + 1}
        end
      end)

    if result.key != "ZZZ" do
      loop(lrs, paths, result.key, result.steps)
    else
      result.steps
    end
  end

  defp loop_2(lrs, paths, key, steps) do
    result =
      Enum.reduce(lrs, %{key: key, steps: steps}, fn lr, acc ->
        IO.inspect(acc)

        if check_key_end(acc.key) do
          acc
        else
          {next_key_l, next_key_r} = Map.get(paths, acc.key)
          next_key = if lr == "L", do: next_key_l, else: next_key_r
          %{key: next_key, steps: acc.steps + 1}
        end
      end)

    if !check_key_end(result.key) do
      loop_2(lrs, paths, result.key, result.steps)
    else
      result.steps
    end
  end

  defp check_key_end(key) do
    key |> String.graphemes() |> Enum.at(2) == "Z"
  end

  defp parse_string(string) do
    lrs =
      string
      |> String.split("\n\n")
      |> Enum.at(0)
      |> String.split("")
      |> Enum.filter(fn c -> c != "" end)
      |> IO.inspect()

    paths =
      string
      |> String.split("\n\n")
      |> Enum.at(1)
      |> String.split("\n")
      |> Enum.map(fn line ->
        Regex.scan(~r/(\w+) = \((\w+), (\w+)\)/, line)
        |> List.flatten()
        |> Enum.drop(1)
      end)
      |> Enum.drop(-1)
      |> Map.new(fn [key, value1, value2] ->
        {key, {value1, value2}}
      end)

    {lrs, paths}
  end

  defp read_file() do
    File.read!("/Users/madlener/git/AOC23/2023/day8/lib/input-8.txt")
  end
end
