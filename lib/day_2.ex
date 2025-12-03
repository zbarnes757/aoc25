defmodule Day2 do
  @input File.read!("inputs/day/2/input.txt")

  def part_one do
    parse_input()
    |> Enum.sum_by(fn {first, last} -> sum_split_repeated(first, last) end)
  end

  def part_two do
    parse_input()
    |> Enum.sum_by(fn {first, last} -> sum_when_repeated_twice(first, last) end)
  end

  # HELPERS

  defp parse_input do
    @input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.split(&1, "-", parts: 2, trim: true))
    |> Enum.map(fn [first, last] -> {String.to_integer(first), String.to_integer(last)} end)
  end

  defp sum_split_repeated(first, last) do
    Enum.sum_by(first..last, fn number ->
      digits = Integer.digits(number)
      {front, back} = split_in_half(digits)

      if front == back do
        number
      else
        0
      end
    end)
  end

  defp sum_when_repeated_twice(first, last) do
    Enum.sum_by(first..last, fn number ->
      str_number = to_string(number)

      Enum.reduce_while(1..String.length(str_number), 0, fn idx, _ ->
        {slice, _} = String.split_at(str_number, idx)
        matches = Regex.scan(Regex.compile!(slice), str_number)
        match_length = length(matches)

        if match_length > 1 and match_length * String.length(slice) == String.length(str_number) do
          {:halt, number}
        else
          {:cont, 0}
        end
      end)
    end)
  end

  defp split_in_half(list) do
    size = length(list)
    split_point = round(size / 2)
    Enum.split(list, split_point)
  end
end
