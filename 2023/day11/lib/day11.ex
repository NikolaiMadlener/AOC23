defmodule Day11 do
  @moduledoc """
  Documentation for `Day11`.
  """

  def sum1 do
    {mapping, matrix} =
      read_file()
      |> parse_string()
      |> transform_lines(2)
      |> transform_rows(2)
      |> numberize()

    IO.inspect(mapping, label: "Mapping")
    IO.inspect(matrix, label: "Matrix")

    pairs = pairs(matrix)
    IO.inspect(pairs, label: "Pairs")

    lengths_sum(pairs, mapping)
  end

  def sum2 do
    {mapping, matrix} =
      read_file()
      |> parse_string()
      |> transform_lines(1)
      |> transform_rows(1)
      |> numberize()

    IO.inspect(mapping, label: "Mapping")
    pairs = pairs(matrix)
    IO.inspect(Enum.count(pairs), label: "Pairs")

    lengths_sum_2(pairs, mapping, matrix)
  end

  defp lengths_sum(pairs, mapping) do
    # iterate over pairs and find distance between them by looking up both positions in matrix
    Enum.reduce(pairs, 0, fn {p1, p2}, acc ->
      acc + distance(p1, p2, mapping)
    end)
  end

  defp lengths_sum_2(pairs, mapping, matrix) do
    # iterate over pairs and find distance between them by looking up both positions in matrix
    pairs
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{p1, p2}, index}, acc ->
      progress = index / Enum.count(pairs) * 100
      IO.inspect(progress, label: "Progress %")
      acc + distance_2(p1, p2, mapping, matrix)
    end)
  end

  defp distance_2(p1, p2, mapping, matrix) do
    # lookup in map
    p1 = Map.get(mapping, p1)
    p2 = Map.get(mapping, p2)

    empty_lines_indexes = matrix |> empty_indexes()
    empty_rows_indexes = matrix |> convert_matrix() |> empty_indexes()

    # IO.inspect(empty_lines_indexes, label: "Empty lines")
    # count how many empty lines are between p1.x and p2.x
    # IO.inspect({p1, p2})

    empty_lines = count_empty_lines(p1, p2, empty_lines_indexes)
    # manhatten distance
    empty_rows = count_empty_rows(p1, p2, empty_rows_indexes)

    distance =
      abs(p1.x - p2.x) + empty_rows * (1_000_000 - 1) + abs(p1.y - p2.y) +
        empty_lines * (1_000_000 - 1)

    # IO.inspect(distance, label: "distance")
  end

  defp count_empty_lines(p1, p2, empty_lines_indexes) when p1.x < p2.x do
    Enum.count(empty_lines_indexes, fn x -> x > p1.x && x < p2.x end)
  end

  defp count_empty_lines(p1, p2, empty_lines_indexes) when p1.x >= p2.x do
    Enum.count(empty_lines_indexes, fn x -> x > p2.x && x < p1.x end)
  end

  defp count_empty_rows(p1, p2, empty_rows_indexes) when p1.y < p2.y do
    Enum.count(empty_rows_indexes, fn x -> x > p1.y && x < p2.y end)
  end

  defp count_empty_rows(p1, p2, empty_rows_indexes) when p1.y >= p2.y do
    Enum.count(empty_rows_indexes, fn x -> x > p2.y && x < p1.y end)
  end

  defp empty_indexes(matrix) do
    matrix
    |> Enum.with_index()
    |> Enum.reduce([], fn {line, index}, acc ->
      # IO.inspect(acc)
      # IO.inspect(line)

      if Enum.all?(line, fn x ->
           if is_integer(x) do
             false
           else
             x == "."
           end
         end) do
        Enum.concat(acc, [index])
      else
        acc
      end
    end)
  end

  defp distance(p1, p2, mapping) do
    # lookup in map
    p1 = Map.get(mapping, p1)
    p2 = Map.get(mapping, p2)

    # manhatten distance
    abs(p1.x - p2.x) + abs(p1.y - p2.y)
  end

  defp pairs(matrix) do
    biggest_val =
      matrix
      |> List.flatten()
      |> Enum.filter(fn x -> x != "." end)
      |> Enum.max()

    # find all pairs 1 to biggest_val (no duplications, eg. {1,2} {2,1} is same)
    Enum.map(1..biggest_val, fn i ->
      Enum.map(1..biggest_val, fn j ->
        {i, j}
      end)
    end)
    |> List.flatten()
    |> Enum.map(fn {i, j} ->
      if i < j, do: {i, j}, else: {j, i}
    end)
    |> Enum.uniq()
  end

  defp numberize(matrix) do
    # replace all # with numbers in matrix (starting at 1)
    amount =
      matrix
      |> List.flatten()
      |> Enum.count(fn x -> x == "#" end)

    range = 1..amount

    # indexing
    # %{1 => {x,y}, 2 => {x,y}, 3 => {x,y}, ...}
    {mapping, matrix_new} =
      Enum.reduce(range, {%{}, matrix}, fn i, acc ->
        {mapping, matrix} = acc
        {x, y} = find_element_indices(matrix, "#")
        mapping_acc = Map.put(mapping, i, %{x: x, y: y})
        matrix_acc = replace_element(matrix, "#", i)
        {mapping_acc, matrix_acc}
      end)
  end

  defp replace_element(matrix, element, replacement) do
    {x, y} = find_element_indices(matrix, element)
    List.replace_at(matrix, x, List.replace_at(Enum.at(matrix, x), y, replacement))
  end

  defp find_element_indices(matrix, element) do
    {row, col} =
      matrix
      |> Enum.with_index()
      |> Enum.map(fn {line, index} ->
        {line, index}
      end)
      |> Enum.map(fn {line, index} ->
        {index, Enum.find_index(line, fn x -> x == element end)}
      end)
      |> Enum.filter(fn {row, col} ->
        row != nil && col != nil
      end)
      |> Enum.at(0)
  end

  defp transform_lines(matrix, amount) do
    line_length = Enum.count(Enum.at(matrix, 0))

    matrix =
      matrix
      |> Enum.map(fn line ->
        dupl_line = line

        if Enum.all?(line, fn x -> x == "." end) do
          # concat line #amount of times
          dupl_line =
            Enum.reduce(1..amount, [], fn _, acc ->
              Enum.concat(acc, line)
            end)
        else
          [line]
        end
      end)
      |> Enum.map(fn line ->
        List.flatten(line)
      end)
      |> Enum.map(fn line ->
        if Enum.count(line) > line_length do
          # split line
          line
          |> Enum.chunk_every(line_length)
        else
          line
        end
      end)
      |> List.flatten()
      |> Enum.chunk_every(line_length)
  end

  defp transform_rows(matrix, amount) do
    matrix
    |> convert_matrix()
    |> transform_lines(amount)
    |> convert_matrix()
  end

  defp convert_matrix(matrix) do
    # convert matrix (switch rows and lines)
    Enum.zip_with(matrix, &Function.identity/1)
  end

  defp parse_string(string) do
    string
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split("")
      |> Enum.filter(fn x -> x != "" end)
    end)
    |> Enum.filter(fn x -> x != [] end)
  end

  defp read_file() do
    # """
    # ...#......
    # .......#..
    # #.........
    # ..........
    # ......#...
    # .#........
    # .........#
    # ..........
    # .......#..
    # #...#.....
    # """

    File.read!("/Users/madlener/git/AOC23/2023/day11/lib/input-11.txt")
  end
end
