defmodule AdventOfCode.Day06 do
  require IEx

  def part1(args) do
    orbits =
      args
      |> Enum.map(&parse/1)
      |> Enum.into(%{}, fn {a, b} -> {b, a} end)

    # expand(old, MapSet.new(parsed))

    orbits
    |> Enum.map(fn {planet, _center} -> count_orbits(planet, orbits) end)
    |> Enum.sum()
  end

  defp count_orbits(planet, orbits) do
    orbits
    |> Map.get(planet)
    |> case do
      nil ->
        0

      center ->
        1 + count_orbits(center, orbits)
    end
  end

  defp parse(orbit) do
    [orbited, orbiter] = orbit |> String.split(")")

    {orbited, orbiter}
  end

  # defp expand(old, new) do
  #   new
  #   |> Enum.reduce({old, MapSet.new()}, fn {orbited, orbiter}, {old, new} ->
  #     trans_orbiting = old |> Map.get(orbiter, [])

  #     {old, discovered} =
  #       trans_orbiting
  #       |> Enum.reduce({old, MapSet.new()}, fn trans, {old, new} ->
  #         old =
  #           old |> Map.update(trans, [orbited], fn already_known -> [orbited | already_known] end)

  #         new = MapSet.put(new, {orbited, trans})

  #         {old, new}
  #       end)

  #     {old, MapSet.union(new, discovered)}
  #   end)
  #   |> case do
  #     {old, []} -> old
  #     {old, new} -> expand(old, new)
  #   end
  # end

  def part2(args) do
    orbits =
      args
      |> Enum.map(&parse/1)

    rels =
      orbits
      |> Enum.reduce(%{}, fn {planet, center}, rel ->
        rel
        |> Map.update(planet, [center], &[center | &1])
        |> Map.update(center, [planet], &[planet | &1])
      end)

    length =
      ["YOU"]
      |> find_path(rels)
      |> Enum.count()

    length - 2
  end

  defp find_path(path, rels) do
    rels
    |> Map.get(hd(path))
    |> Enum.flat_map(fn next ->
      cond do
        next in path ->
          []

        next == "SAN" ->
          path

        true ->
          find_path([next | path], rels)
      end
    end)
  end
end
