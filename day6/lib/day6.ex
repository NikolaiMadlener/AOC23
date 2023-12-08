defmodule Day6 do
  @moduledoc """
  Documentation for `Day6`.
  """

  def record do
    list = [{49, 298}, {78, 1185}, {79, 1066}, {80, 1181}]

    list
    |> Enum.reduce(1, fn {time, distance_record}, acc ->
      beats = calc_beats(time, distance_record, distance_record)

      acc * beats
    end)
  end

  def record_2 do
    time = 49_787_980
    distance_record = 298_118_510_661_181

    beats = calc_beats(time, distance_record, distance_record)
  end

  defp calc_beats(time, distance, distance_record) do
    Enum.reduce(0..time, 0, fn sec, acc ->
      speed = sec
      distance = (time - sec) * speed
      if distance > distance_record, do: acc + 1, else: acc
    end)
  end
end
