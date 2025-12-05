defmodule Day5 do
  def part_one(path) do
    {ranges, ids} = parse_input(path)
    ids = Enum.sort(ids)
    ranges = Enum.sort(ranges)

    Enum.count(ids, fn id -> Enum.any?(ranges, &(id in &1)) end)
  end

  def part_two(path) do
    {ranges, _ids} = parse_input(path)

    ranges
    |> Enum.sort()
    |> merge_ranges()
    |> Enum.sum_by(&Range.size/1)
  end

  # HELPERS

  defp parse_range(range) when is_binary(range) do
    [first, last] = String.split(range, "-", parts: 2)
    String.to_integer(first)..String.to_integer(last)
  end

  defp parse_input(path) do
    path
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce({[], []}, fn line, {ranges, ids} = acc ->
      cond do
        String.contains?(line, "-") ->
          range = parse_range(line)
          {[range | ranges], ids}

        line == "" ->
          acc

        true ->
          {ranges, [String.to_integer(line) | ids]}
      end
    end)
  end

  defp merge_ranges(ranges, current_range \\ nil)
  defp merge_ranges([], current_range), do: [current_range]
  defp merge_ranges([range | rest], nil), do: merge_ranges(rest, range)

  defp merge_ranges([range | rest], acc_range) do
    if Range.disjoint?(range, acc_range) do
      [acc_range | merge_ranges(rest, range)]
    else
      first..last//_ = range
      acc_first..acc_last//_ = acc_range
      new_range = min(first, acc_first)..max(last, acc_last)
      merge_ranges(rest, new_range)
    end
  end
end
