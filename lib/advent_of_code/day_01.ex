defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> Enum.map(fn mass ->
      Float.floor(mass / 3) - 2
    end)
    |> Enum.reduce(&+/2)
  end

  def part2(args) do
    args
    |> Enum.map(&fuel/1)
    |> Enum.reduce(&+/2)
  end

  defp fuel(mass) do
    (Float.floor(mass / 3) - 2)
    |> case do
      mass when mass > 0 -> mass + fuel(mass)
      mass -> 0
    end
  end
end
