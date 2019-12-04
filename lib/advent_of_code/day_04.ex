defmodule AdventOfCode.Day04 do
  def part1(args) do
    args
    |> Enum.map(&Integer.to_string/1)
    |> Enum.count(&test1/1)
  end

  defp test1(<<a, b, c, d, e, f>>) do
    no_decrease = a <= b and b <= c and c <= d and d <= e and e <= f
    adjacent_equal = a == b or b == c or c == d or d == e or e == f

    no_decrease and adjacent_equal
  end

  def part2(args) do
    args
    |> Enum.map(&Integer.to_string/1)
    |> Enum.count(&test2/1)
  end

  defp test2(<<a, b, c, d, e, f>>) do
    no_decrease = a <= b and b <= c and c <= d and d <= e and e <= f

    adjacent_equal =
      (a == b and not (b == c)) or
        (b == c and not (a == b or c == d)) or
        (c == d and not (b == c or d == e)) or
        (d == e and not (c == d or e == f)) or
        (e == f and not (d == e))

    no_decrease and adjacent_equal
  end
end
