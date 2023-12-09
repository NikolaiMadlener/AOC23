defmodule Day3 do
  @moduledoc """
  Documentation for `Day3`.
  """

  # part 1
  defp part_sum() do
    str = read_file()
    line_length = String.split(str, "\n") |> Enum.at(0) |> String.length()
    # remove all newlines
    string = String.replace(str, "\n", "")

    Regex.scan(~r/\d+/, string, return: :index)
    |> Enum.flat_map(fn match -> match end)
    |> Enum.filter(fn {position, length} ->
      check_number_1(string, position, length) ||
        check_number_2(string, position, length, line_length) ||
        check_number_3(string, position, length, line_length)
    end)
    |> Enum.map(fn {position, length} ->
      String.slice(string, position, length)
    end)
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> Enum.sum()
  end

  # part 2
  def gear_sum() do
    str = read_file()
    line_length = String.split(str, "\n") |> Enum.at(0) |> String.length()
    # remove all newlines
    string = String.replace(str, "\n", "")

    numbers_positions =
      Regex.scan(~r/\d+/, string, return: :index)
      |> Enum.flat_map(fn match -> match end)

    gear_positions =
      Regex.scan(~r/\*/, string, return: :index)
      |> Enum.flat_map(fn match -> match end)
      |> Enum.map(fn {position, length} -> position end)
      |> IO.inspect()

    gear_numbers =
      Enum.map(gear_positions, fn position ->
        adj_points =
          [
            position - 1,
            position + 1,
            position - line_length - 1,
            position - line_length,
            position - line_length + 1,
            position + line_length - 1,
            position + line_length,
            position + line_length + 1
          ]
          |> Enum.filter(fn pos ->
            pos >= 0 && pos < String.length(string)
          end)

        adj_numbers =
          numbers_positions
          |> Enum.filter(fn {pos, length} ->
            interval = pos..(pos + length - 1)

            Enum.any?(adj_points, fn point ->
              point in interval
            end)
          end)
          |> Enum.map(fn {pos, length} ->
            String.slice(string, pos, length)
          end)

        IO.inspect(%{gear_position: position, gear_numbers: adj_numbers})
        %{gear_position: position, gear_numbers: adj_numbers}
      end)

    gear_numbers
    |> Enum.filter(fn %{gear_position: position, gear_numbers: adj_numbers} ->
      Enum.count(adj_numbers) == 2
    end)
    |> Enum.map(fn %{gear_position: position, gear_numbers: adj_numbers} ->
      String.to_integer(Enum.at(adj_numbers, 0)) * String.to_integer(Enum.at(adj_numbers, 1))
    end)
    |> Enum.sum()
  end

  defp check_number_1(string, position, length) do
    # check direct next and direct before
    if position > 0 && position < String.length(string) do
      char_before = String.at(string, position - 1)
      char_after = String.at(string, position + length)
      # return true if char before or after is not a dot
      char_before != "." || char_after != "."
    end
  end

  defp check_number_2(string, position, length, line_length) do
    # check behind
    if position > line_length do
      String.slice(string, position - line_length - 1, length + 2)
      |> String.split("")
      |> Enum.filter(fn char ->
        char != ""
      end)
      # check if one of the chars is neither a dot nor a digit
      |> check_chars()
    end
  end

  defp check_number_3(string, position, length, line_length) do
    if position < String.length(string) - line_length do
      # check chars are not dot from position+line_length-1 to position+line_length+length+1
      String.slice(string, position + line_length - 1, length + 2)
      |> String.split("")
      |> Enum.filter(fn char ->
        char != ""
      end)
      # check if one of the chars is neither a dot nor a digit
      |> check_chars()
    end
  end

  defp check_chars(char_list) do
    char_list
    |> Enum.any?(fn char ->
      char != "." && !String.contains?(char, ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
    end)
  end

  defp read_file() do
    File.read!("/Users/madlener/git/AOC23/2023/day3/lib/input-3.txt")
  end
end
