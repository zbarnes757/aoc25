defmodule Day3 do
  @input File.read!("inputs/day/3/input.txt")

  def part_one do
    parse_input()
    |> Enum.sum_by(&sum_largest_joltage/1)
  end

  def part_two do
    parse_input()
    |> Enum.sum_by(&sum_largest_twelve_joltages/1)
  end

  # HELPERS

  defp sum_largest_joltage(bank) do
    digits = Integer.digits(bank)

    {first_digit, idx} =
      digits
      |> Enum.slice(0..-2//1)
      |> Enum.with_index()
      |> Enum.max_by(fn {value, _idx} -> value end)

    second_digit =
      digits
      |> Enum.slice((idx + 1)..-1//1)
      |> Enum.max()

    first_digit * 10 + second_digit
  end

  defp sum_largest_twelve_joltages(bank) do
    digits = Integer.digits(bank)
    continue_grabbing_next_max_value(digits, 12)
  end

  defp continue_grabbing_next_max_value(_rest, 0 = _remaining), do: 0

  defp continue_grabbing_next_max_value(rest, remaining) when length(rest) == remaining do
    rest
    |> Enum.map(&to_string/1)
    |> Enum.join()
    |> String.to_integer()
  end

  defp continue_grabbing_next_max_value(rest, remaining) do
    {next_digit, idx} =
      rest
      |> Enum.slice(0..-remaining//1)
      |> Enum.with_index()
      |> Enum.max_by(fn {value, _idx} -> value end)
      |> then(fn {first_digit, idx} -> {first_digit * Integer.pow(10, remaining - 1), idx} end)

    rest
    |> Enum.slice((idx + 1)..-1//1)
    |> continue_grabbing_next_max_value(remaining - 1)
    |> then(&(&1 + next_digit))
  end

  defp parse_input do
    @input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end
end
