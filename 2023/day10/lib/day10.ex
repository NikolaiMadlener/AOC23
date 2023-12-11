defmodule Day10 do
  @moduledoc """
  Documentation for `Day10`.
  """

  def loop do
    matrix =
      read_file()
      |> parse_string()

    start_pos = find_start_pos(matrix)
    recursive_loop(start_pos, start_pos, 0, 0, matrix)
  end

  defp find_start_pos(matrix) do
    # todo
    x =
      Enum.find_index(matrix, fn row ->
        Enum.find_index(row, fn char ->
          char == "S"
        end)
      end)

    y =
      Enum.at(matrix, x)
      |> Enum.find_index(fn char ->
        char == "S"
      end)

    IO.inspect(y, label: "Start pos:")
    {x, y}
  end

  defp recursive_loop(pos1, pos2, acc1, acc2, matrix) do
    # update pos1 with acc1 + 1
    {x1, y1} = pos1
    current_char = Enum.at(Enum.at(matrix, x1), y1)

    # look in all 4 directions of pos 1
    {x1_new, y1_new} =
      case current_char do
        "S" -> check_directions1(matrix, pos1)
        "|" -> check_up_down(matrix, pos1)
        "-" -> check_left_right(matrix, pos1)
        "L" -> check_up_right(matrix, pos1)
        "J" -> check_up_left(matrix, pos1)
        "7" -> check_down_left(matrix, pos1)
        "F" -> check_down_right(matrix, pos1)
        _ -> nil
      end

    # update pos2 with acc2 + 1
    {x2, y2} = pos2

    current_char = Enum.at(Enum.at(matrix, x2), y2)

    # look in all 4 directions of pos 1
    {x2_new, y2_new} =
      case current_char do
        "S" -> check_directions2(matrix, pos2)
        "|" -> check_up_down(matrix, pos2)
        "-" -> check_left_right(matrix, pos2)
        "L" -> check_up_right(matrix, pos2)
        "J" -> check_up_left(matrix, pos2)
        "7" -> check_down_left(matrix, pos2)
        "F" -> check_down_right(matrix, pos2)
        _ -> nil
      end

    matrix =
      List.update_at(matrix, x1, fn row ->
        List.update_at(row, y1, fn _ ->
          acc1
        end)
      end)

    matrix =
      List.update_at(matrix, x2, fn row ->
        List.update_at(row, y2, fn _ ->
          acc2
        end)
      end)

    if x1_new == x2_new && y1_new == y2_new do
      matrix =
        List.update_at(matrix, x1_new, fn row ->
          List.update_at(row, y1_new, fn _ ->
            acc1 + 1
          end)
        end)

      IO.inspect(matrix)

      acc1 + 1
    else
      recursive_loop({x1_new, y1_new}, {x2_new, y2_new}, acc1 + 1, acc2 + 1, matrix)
    end
  end

  defp check_directions1(matrix, pos) do
    cond do
      check_down(matrix, pos) != nil -> check_down(matrix, pos)
      check_right(matrix, pos) != nil -> check_right(matrix, pos)
      check_up(matrix, pos) != nil -> check_up(matrix, pos)
      check_left(matrix, pos) != nil -> check_left(matrix, pos)
    end
  end

  defp check_directions2(matrix, pos) do
    cond do
      check_left(matrix, pos) != nil -> check_left(matrix, pos)
      check_up(matrix, pos) != nil -> check_up(matrix, pos)
      check_right(matrix, pos) != nil -> check_right(matrix, pos)
      check_down(matrix, pos) != nil -> check_down(matrix, pos)
    end
  end

  defp check_up_down(matrix, pos) do
    cond do
      check_up(matrix, pos) != nil -> check_up(matrix, pos)
      check_down(matrix, pos) != nil -> check_down(matrix, pos)
    end
  end

  defp check_left_right(matrix, pos) do
    cond do
      check_left(matrix, pos) != nil -> check_left(matrix, pos)
      check_right(matrix, pos) != nil -> check_right(matrix, pos)
    end
  end

  defp check_up_right(matrix, pos) do
    cond do
      check_up(matrix, pos) != nil -> check_up(matrix, pos)
      check_right(matrix, pos) != nil -> check_right(matrix, pos)
    end
  end

  defp check_up_left(matrix, pos) do
    cond do
      check_up(matrix, pos) != nil -> check_up(matrix, pos)
      check_left(matrix, pos) != nil -> check_left(matrix, pos)
    end
  end

  defp check_down_left(matrix, pos) do
    cond do
      check_down(matrix, pos) != nil -> check_down(matrix, pos)
      check_left(matrix, pos) != nil -> check_left(matrix, pos)
    end
  end

  defp check_down_right(matrix, pos) do
    cond do
      check_down(matrix, pos) != nil -> check_down(matrix, pos)
      check_right(matrix, pos) != nil -> check_right(matrix, pos)
    end
  end

  defp check_left(matrix, pos) do
    {x, y} = pos
    left_char = Enum.at(Enum.at(matrix, x), y - 1)

    case left_char do
      "-" -> {x, y - 1}
      "L" -> {x, y - 1}
      "F" -> {x, y - 1}
      _ -> nil
    end
  end

  defp check_up(matrix, pos) do
    {x, y} = pos
    upper_char = Enum.at(Enum.at(matrix, x - 1), y)

    case upper_char do
      "|" -> {x - 1, y}
      "7" -> {x - 1, y}
      "F" -> {x - 1, y}
      _ -> nil
    end
  end

  defp check_right(matrix, pos) do
    {x, y} = pos
    right_char = Enum.at(Enum.at(matrix, x), y + 1)

    case right_char do
      "-" -> {x, y + 1}
      "7" -> {x, y + 1}
      "J" -> {x, y + 1}
      _ -> nil
    end
  end

  defp check_down(matrix, pos) do
    {x, y} = pos
    lower_char = Enum.at(Enum.at(matrix, x + 1), y)

    case lower_char do
      "|" -> {x + 1, y}
      "J" -> {x + 1, y}
      "L" -> {x + 1, y}
      _ -> nil
    end
  end

  defp parse_string(string) do
    matrix =
      string
      |> String.split("\n")
      |> Enum.map(fn line ->
        line
        |> String.split("")
        |> Enum.filter(fn x -> x != "" end)
      end)
      |> Enum.filter(fn x -> x != [] end)

    IO.inspect(matrix)
    matrix
  end

  defp read_file() do
    # """
    # ..F7.
    # .FJ|.
    # SJ.L7
    # |F--J
    # LJ...
    # """

    File.read!("/Users/madlener/git/AOC23/2023/day10/lib/input-10.txt")
  end
end
