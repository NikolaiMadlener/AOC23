defmodule Day4 do
  @moduledoc """
  Documentation for `Day4`.
  """

  def point_sum() do
    read_file()
    |> parse_string()
    |> Enum.map(fn %{card: card, winning_numbers: winning_numbers, numbers: numbers} ->
      calc_score(numbers, winning_numbers)
    end)
    |> Enum.sum()
  end

  def scratchcard_sum() do
    new_list =
      read_file()
      |> parse_string()
      |> Enum.map(fn %{card: card, winning_numbers: winning_numbers, numbers: numbers} ->
        %{card: card, amount: calc_number_winning_cards(numbers, winning_numbers)}
      end)

    recursive_scratchcard(new_list, new_list) |> Enum.count()
  end

  defp recursive_scratchcard(new_list, original_list) do
    Enum.map(new_list, fn %{card: card, amount: amount} ->
      if amount == 0 do
        %{card: card, amount: amount}
      else
        Enum.concat(
          [%{card: card, amount: amount}],
          Enum.filter(original_list, fn %{card: card2} ->
            card2 >= card + 1 && card2 <= card + amount
          end)
          |> recursive_scratchcard(original_list)
        )
      end
    end)
    |> List.flatten()
  end

  defp calc_number_winning_cards(numbers, winning_numbers) do
    Enum.map(numbers, fn number ->
      if Enum.member?(winning_numbers, number), do: 1, else: 0
    end)
    |> Enum.sum()
  end

  defp calc_score(numbers, winning_numbers) do
    list =
      Enum.map(numbers, fn number ->
        if Enum.member?(winning_numbers, number), do: 1, else: 0
      end)
      |> Enum.filter(fn x -> x == 1 end)

    if Enum.count(list) == 0, do: 0, else: 2 ** (Enum.count(list) - 1)
  end

  defp parse_string(string) do
    string
    |> String.replace(~r/Card /, "")
    |> String.split("\n")
    |> Enum.map(fn line ->
      card_number = String.slice(line, 0..2) |> String.trim() |> String.to_integer()

      parse_numbers = fn idx ->
        String.split(line, ":")
        |> Enum.at(1)
        |> String.split("|")
        |> Enum.at(idx)
        |> String.trim()
        |> String.split(" ")
        |> Enum.filter(&(&1 != ""))
        |> Enum.map(&String.to_integer/1)
      end

      %{card: card_number, winning_numbers: parse_numbers.(0), numbers: parse_numbers.(1)}
    end)
  end

  defp read_file() do
    File.read!("/Users/madlener/git/AOC23/day4/lib/input-4.txt")
  end
end
