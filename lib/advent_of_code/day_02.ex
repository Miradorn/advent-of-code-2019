defmodule AdventOfCode.Day02 do
  def part1([op, _, _ | rest]) do
    process([op, 12, 2 | rest], 0)
  end

  def part2([op, _, _ | rest]) do
    {noun, verb} =
      for noun <- 1..100, verb <- 1..100 do
        [op, noun, verb | rest]
        |> process(0)
        |> hd
        |> case do
          19_690_720 -> {noun, verb}
          _ -> nil
        end
      end
      |> Enum.reject(fn v -> v == nil end)
      |> hd

    100 * noun + verb
  end

  defp process(list, position) do
    # get op_line
    {ret, ret_pos} =
      list
      |> Enum.slice(position, 4)
      |> case do
        [99 | _rest] ->
          {:exit, nil}

        [1, arg_1, arg_2, ret_pos] ->
          {Enum.at(list, arg_1) + Enum.at(list, arg_2), ret_pos}

        [2, arg_1, arg_2, ret_pos] ->
          {Enum.at(list, arg_1) * Enum.at(list, arg_2), ret_pos}
      end

    if ret != :exit do
      list = List.replace_at(list, ret_pos, ret)
      process(list, position + 4)
    else
      list
    end
  end
end
