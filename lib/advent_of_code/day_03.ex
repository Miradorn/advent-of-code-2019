defmodule AdventOfCode.Day03 do
  def part1([first, second]) do
    %{}
    |> trace(first, :first)
    |> trace(second, :second)
    |> Enum.into(%{}, fn {x, line} ->
      line = line |> Enum.filter(fn {_y, marker} -> marker == :cross end)
      {x, line}
    end)
    |> Enum.reject(fn {_x, y} -> y == [] end)
    |> Enum.flat_map(fn {x, list} ->
      list
      |> Enum.map(fn {y, _} ->
        x = abs(x)
        y = abs(y)
        x + y
      end)
    end)
    |> Enum.min()
  end

  defp trace(map, path, run) do
    pos = {0, 0}

    {_pos, map} =
      path
      |> Enum.reduce({pos, map}, fn instr, {pos, map} ->
        <<dir::utf8, steps::binary>> = instr
        steps = String.to_integer(steps)

        walk(pos, dir, steps, map, run)
      end)

    map
  end

  defp walk(pos, dir, steps, map, run) do
    1..steps
    |> Enum.reduce({pos, map}, fn _step, {{x, y}, map} ->
      {x, y} = do_step(x, y, dir)
      map = set_step(map, x, y, run)

      {{x, y}, map}
    end)
  end

  defp do_step(x, y, ?R), do: {x + 1, y}
  defp do_step(x, y, ?L), do: {x - 1, y}
  defp do_step(x, y, ?U), do: {x, y + 1}
  defp do_step(x, y, ?D), do: {x, y - 1}

  defp set_step(map, x, y, run) do
    map
    |> Map.update(x, %{y => run}, fn line ->
      Map.update(line, y, run, fn
        marker when marker == run -> run
        _run -> :cross
      end)
    end)
  end

  def part2(args) do
  end
end
