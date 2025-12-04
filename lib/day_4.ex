defmodule Day4 do
  def part_one(path) do
    {grid, row_count, column_count} = parse_input(path)

    {count, _} = do_removal(grid, row_count, column_count)
    count
  end

  def part_two(path) do
    {grid, row_count, column_count} = parse_input(path)

    absolute_removal(grid, row_count, column_count)
  end

  # HELPERS

  defp parse_input(path) do
    rows =
      path
      |> File.read!()
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.split(&1, "", trim: true))

    {parse_grid(rows), length(rows), length(hd(rows))}
  end

  defp parse_grid(rows) do
    for {row, r_idx} <- Enum.with_index(rows),
        {cell, c_idx} <- Enum.with_index(row),
        into: %{},
        do: {{r_idx, c_idx}, cell}
  end

  defp neighbor_coordinates({r, c}) do
    for v <- -1..1,
        h <- -1..1,
        {v, h} != {0, 0},
        do: {r + v, c + h}
  end

  defp do_removal(grid, row_count, column_count, count \\ 0) do
    for row <- 0..(row_count - 1),
        column <- 0..(column_count - 1),
        Map.get(grid, {row, column}) == "@",
        reduce: {count, []} do
      {this_count, removed} ->
        neighbor_count =
          {row, column}
          |> neighbor_coordinates()
          |> Enum.count(&(Map.get(grid, &1) == "@"))

        if neighbor_count < 4,
          do: {this_count + 1, [{row, column} | removed]},
          else: {this_count, removed}
    end
  end

  defp absolute_removal(grid, row_count, column_count, total \\ 0) do
    {total, removed} = do_removal(grid, row_count, column_count, total)

    case removed do
      [] ->
        total

      _ ->
        removed
        |> Map.new(&{&1, "."})
        |> then(&Map.merge(grid, &1))
        |> then(&absolute_removal(&1, row_count, column_count, total))
    end
  end
end
