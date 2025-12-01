defmodule Day1 do
  @input File.read!("inputs/day/1/input.txt")

  @start %{position: 50, zeros: 0}

  def part_one do
    parse_input()
    |> Enum.reduce(@start, fn rotation, %{position: position} = acc ->
      position = Integer.mod(position + rotation, 100)

      if position == 0 do
        %{acc | position: position, zeros: acc.zeros + 1}
      else
        %{acc | position: position}
      end
    end)
  end

  def part_two do
    parse_input()
    |> Enum.reduce(@start, fn rotation, %{position: prev_position, zeros: zeros} ->
      new_position = prev_position + rotation
      zero_crossings = abs(div(new_position, 100))

      zero_crossings =
        if new_position <= 0 and prev_position != 0 do
          zero_crossings + 1
        else
          zero_crossings
        end

      %{position: Integer.mod(new_position, 100), zeros: zeros + zero_crossings}
    end)
  end

  defp parse_input do
    @input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "", parts: 2, trim: true))
    |> Enum.reject(&(length(&1) == 0))
    |> Enum.map(fn [direction, rotations] ->
      case direction do
        "R" -> String.to_integer(rotations)
        "L" -> String.to_integer(rotations) * -1
      end
    end)
  end
end
