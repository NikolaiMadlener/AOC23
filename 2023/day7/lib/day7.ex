defmodule Day7 do
  @moduledoc """
  Documentation for `Day7`.
  """

  def winning() do
    read_file()
    |> parse_cards()
    |> rank_cards()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{hand, bid}, index}, acc ->
      IO.inspect({hand, bid}, label: index + 1)
      (acc + bid * (index + 1)) |> IO.inspect()
    end)
  end

  def winning_2() do
    read_file()
    |> parse_cards()
    |> rank_cards_2()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{hand, bid}, index}, acc ->
      IO.inspect({hand, bid}, label: index + 1)
      (acc + bid * (index + 1)) |> IO.inspect()
    end)
  end

  defp parse_cards(string) do
    string
    |> String.split("\n")
    |> Enum.filter(fn line -> line != "" end)
    |> Enum.map(fn line ->
      line
      |> String.split(" ")
      # transform [hand, bid] to {hand, bid}
      |> transform_to_tuple()
    end)
  end

  defp transform_to_tuple([hand, bid]) do
    {hand, String.to_integer(bid)}
  end

  defp rank_cards(tuple_list) do
    # lowest card first, highest card last
    Enum.sort(tuple_list, fn {hand1, bid1}, {hand2, bid2} ->
      strength1 = get_strength(hand1)
      strength2 = get_strength(hand2)

      if strength1 == strength2 do
        second_rule(hand1, hand2)
      else
        strength1 < strength2
      end
    end)
  end

  defp rank_cards_2(tuple_list) do
    # lowest card first, highest card last
    Enum.sort(tuple_list, fn {hand1, bid1}, {hand2, bid2} ->
      strength1 = get_strength_2(hand1)
      strength2 = get_strength_2(hand2)

      if strength1 == strength2 do
        second_rule_2(hand1, hand2)
      else
        strength1 < strength2
      end
    end)
  end

  defp second_rule(hand1, hand2) do
    hand1 = hand1 |> String.graphemes()
    hand2 = hand2 |> String.graphemes()

    cards = get_cards(hand1, hand2)

    # A > K > Q > J > T > 9 > 8 > 7 > 6 > 5 > 4 > 3 > 2
    map_char_to_num(Enum.at(cards, 0)) < map_char_to_num(Enum.at(cards, 1))
  end

  defp get_cards(hand1, hand2) do
    Enum.find_value(0..4, fn index ->
      card_hand_1 = Enum.at(hand1, index)
      card_hand_2 = Enum.at(hand2, index)

      if card_hand_1 == card_hand_2 do
        nil
      else
        [card_hand_1, card_hand_2]
      end
    end)
  end

  defp second_rule_2(hand1, hand2) do
    hand1 = hand1 |> String.graphemes()
    hand2 = hand2 |> String.graphemes()

    cards = get_cards(hand1, hand2)

    # A > K > Q > J > T > 9 > 8 > 7 > 6 > 5 > 4 > 3 > 2
    map_char_to_num_2(Enum.at(cards, 0)) < map_char_to_num_2(Enum.at(cards, 1))
  end

  defp map_char_to_num(char) do
    case char do
      "A" -> 14
      "K" -> 13
      "Q" -> 12
      "J" -> 11
      "T" -> 10
      _ -> String.to_integer(char)
    end
  end

  defp map_char_to_num_2(char) do
    case char do
      "A" -> 13
      "K" -> 12
      "Q" -> 11
      "J" -> 1
      "T" -> 10
      _ -> String.to_integer(char)
    end
  end

  defp get_strength(hand) do
    occurencies =
      hand |> String.graphemes() |> Enum.frequencies() |> Map.values() |> Enum.sort(:desc)

    map_occurencies(occurencies)
  end

  defp map_occurencies(occurencies) do
    case occurencies do
      [5] -> 7
      [4, 1] -> 6
      [3, 2] -> 5
      [3, 1, 1] -> 4
      [2, 2, 1] -> 3
      [2, 1, 1, 1] -> 2
      [1, 1, 1, 1, 1] -> 1
    end
  end

  defp get_strength_2(hand) do
    occurencies =
      hand
      |> String.graphemes()
      |> Enum.frequencies()
      |> Map.to_list()
      |> Enum.sort(fn {key1, value1}, {key2, value2} ->
        value1 > value2
      end)

    # move element with key "J" to the end
    {matched, rest} =
      occurencies
      |> Enum.partition(fn {key, _} -> key == "J" end)

    occurencies = rest ++ matched

    occurencies =
      occurencies
      |> Enum.with_index()
      |> Enum.map(fn {{card, occurence}, index} ->
        if index == 0 do
          if card == "J" && occurence == 5 do
            {card, occurence}
          else
            {card, occurence + j_occurences(hand)}
          end
        else
          {card, occurence}
        end
      end)
      |> Enum.filter(fn {key, val} ->
        if val < 5 do
          key != "J"
        else
          true
        end
      end)
      |> Enum.map(fn {_, value} -> value end)
      |> Enum.sort(:desc)

    map_occurencies(occurencies)
  end

  defp j_occurences(hand) do
    hand |> String.graphemes() |> Enum.filter(fn card -> card == "J" end) |> Enum.count()
  end

  defp read_file() do
    File.read!("/Users/madlener/git/AOC23/2023/day7/lib/input-7.txt")
  end
end
