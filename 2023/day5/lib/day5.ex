defmodule Day5 do
  @moduledoc """
  Documentation for `Day5`.
  """

  def lowest do
    lookups = read_file() |> parse_string_lookups()
    seeds = read_file() |> parse_string_seeds()

    seeds
    |> Enum.map(fn seed ->
      lookups
      |> Enum.reduce(seed, fn lookup_list, acc ->
        lookup_line =
          Enum.find(lookup_list, fn lookup ->
            source = Enum.at(lookup, 1)
            range = Enum.at(lookup, 2)
            acc in source..(source + range - 1)
          end)

        lookup(acc, lookup_line)
      end)
    end)
    |> Enum.min()
  end

  def lowest_2() do
    read_file() |> parse_string_seeds_part2()
  end

  defp parse_string_lookups(string) do
    string
    |> String.split("\n\n")
    |> Enum.drop(1)
    |> Enum.map(fn string -> String.split(string, ":") |> Enum.at(1) end)
    |> Enum.map(fn line -> line |> String.split("\n") end)
    |> Enum.map(fn sub_list -> Enum.reject(sub_list, fn x -> x == "" end) end)
    |> Enum.map(fn sub_list -> conv_int(sub_list) end)
  end

  defp conv_int(string_list) do
    string_list
    |> Enum.map(fn string ->
      String.split(string, " ") |> Enum.map(fn x -> String.to_integer(x) end)
    end)
  end

  defp parse_string_seeds(string) do
    string
    |> String.split("\n\n")
    |> Enum.at(0)
    |> String.trim("seeds: ")
    |> String.split(" ")
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  defp parse_string_seeds_part2(string) do
    seeds_ranges =
      parse_string_seeds(string)
      |> Enum.chunk_every(2)
      |> Enum.map(fn pair ->
        start = Enum.at(pair, 0)
        range = Enum.at(pair, 1)
        # generate numbers between start and start + range -1
        stop = start + range - 1
        [start, stop]
      end)

    lookups = read_file() |> parse_string_lookups()
    lookups = Enum.reverse(lookups)

    Enum.find_value(0..300_000_000, fn location ->
      potential_seed =
        lookups
        |> Enum.reduce(location, fn lookup_list, acc ->
          lookup_line =
            Enum.find(lookup_list, fn lookup ->
              source = Enum.at(lookup, 0)
              range = Enum.at(lookup, 2)
              acc in source..(source + range - 1)
            end)

          lookup_reverse(acc, lookup_line)
        end)

      # find the seed range for the potential seed
      range =
        Enum.find(seeds_ranges, fn seed_range ->
          potential_seed in Enum.at(seed_range, 0)..Enum.at(seed_range, 1)
        end)

      IO.inspect(location / 300_000_000)

      if range != nil, do: location
    end)
  end

  defp lookup(source, lookup_line) when lookup_line != nil do
    destination_start = Enum.at(lookup_line, 0)
    source_start = Enum.at(lookup_line, 1)
    range = Enum.at(lookup_line, 2)
    lookup(source, destination_start, source_start, range)
  end

  defp lookup(source, lookup_line) do
    source
  end

  defp lookup(source, destination_start, source_start, range)
       when source in source_start..(source_start + range - 1) do
    diff = Kernel.abs(destination_start - source_start)
    # if destination is smaller than source, we have to subtract the diff to the seed
    if destination_start < source_start, do: source - diff, else: source + diff
  end

  defp lookup_reverse(source, lookup_line) when lookup_line != nil do
    destination_start = Enum.at(lookup_line, 1)
    source_start = Enum.at(lookup_line, 0)
    range = Enum.at(lookup_line, 2)
    lookup_reverse(source, destination_start, source_start, range)
  end

  defp lookup_reverse(source, lookup_line) do
    source
  end

  defp lookup_reverse(source, destination_start, source_start, range)
       when source in source_start..(source_start + range - 1) do
    diff = Kernel.abs(destination_start - source_start)
    # if destination is smaller than source, we have to subtract the diff to the seed
    if destination_start < source_start, do: source - diff, else: source + diff
  end

  defp read_file() do
    File.read!("/Users/madlener/git/AOC23/2023/day5/lib/input-5.txt")
  end
end
