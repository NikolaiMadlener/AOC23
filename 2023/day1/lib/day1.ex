defmodule Day1 do
  @moduledoc """
  Documentation for `Day1`.
  """

  defp parse_string_to_int(string) do
    string
    |> spelled_digit_to_digit()
    |> String.replace(~r/[^\d]/, "")
    |> empty_string_to_zero()
    |> double_single_digit()
    |> trim_long_digit()
    |> String.to_integer()
  end

  defp spelled_digit_to_digit(word_with_spelled_digit) do
    word_with_spelled_digit
    |> String.replace("one", "o1e")
    |> String.replace("two", "t2o")
    |> String.replace("three", "t3e")
    |> String.replace("four", "f4r")
    |> String.replace("five", "f5e")
    |> String.replace("six", "s6x")
    |> String.replace("seven", "s7n")
    |> String.replace("eight", "e8t")
    |> String.replace("nine", "n9e")
  end

  defp empty_string_to_zero(digits) do
    if digits == "" do
      "0"
    else
      digits
    end
  end

  defp double_single_digit(digits) do
    if String.length(digits) == 1 do
      digits <> digits
    else
      digits
    end
  end

  defp trim_long_digit(digits) do
    if String.length(digits) > 2 do
      String.replace(digits, ~r/(\d)(\d+)(\d)/, "\\1\\3")
    else
      digits
    end
  end

  defp read_file() do
    File.read!("/Users/madlener/git/AOC23/2023/day1/lib/input.txt")
    |> String.split("\n")
  end

  def calc_sum() do
    read_file()
    |> Enum.map(&parse_string_to_int/1)
    |> Enum.sum()
  end
end
