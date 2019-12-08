defmodule AdventOfCode.Day05 do
  def part1(program) do
    process(program, 0)
  end

  def part2(program), do: process(program, 0)

  defp process(program, position) do
    # get op_line

    op = program |> Enum.at(position)

    op
    |> rem(100)
    |> case do
      1 ->
        {arg1, arg2, addr} = two_args_and_addr(program, op, position)

        program
        |> List.replace_at(addr, arg1 + arg2)
        |> process(position + 4)

      2 ->
        {arg1, arg2, addr} = two_args_and_addr(program, op, position)

        program
        |> List.replace_at(addr, arg1 * arg2)
        |> process(position + 4)

      3 ->
        addr = Enum.at(program, position + 1)
        IO.puts("Input:")
        {input, _} = IO.read(:line) |> Integer.parse()

        program
        |> List.replace_at(addr, input)
        |> process(position + 2)

      4 ->
        arg = one_arg(program, op, position)
        IO.puts(arg |> Integer.to_string())

        program
        |> process(position + 2)

      5 ->
        {arg1, arg2} = two_args(program, op, position)

        if arg1 != 0 do
          process(program, arg2)
        else
          process(program, position + 3)
        end

      6 ->
        {arg1, arg2} = two_args(program, op, position)

        if arg1 == 0 do
          process(program, arg2)
        else
          process(program, position + 3)
        end

      7 ->
        {arg1, arg2, addr} = two_args_and_addr(program, op, position)

        val = if arg1 < arg2, do: 1, else: 0

        program
        |> List.replace_at(addr, val)
        |> process(position + 4)

      8 ->
        {arg1, arg2, addr} = two_args_and_addr(program, op, position)

        val = if arg1 == arg2, do: 1, else: 0

        program
        |> List.replace_at(addr, val)
        |> process(position + 4)

      99 ->
        {:exit, nil}
    end
  end

  defp two_args(program, op, position) do
    mode1 = op |> div(100) |> rem(10)
    mode2 = op |> div(1000) |> rem(100)

    arg1 =
      if mode1 == 1 do
        Enum.at(program, position + 1)
      else
        addr = Enum.at(program, position + 1)
        Enum.at(program, addr)
      end

    arg2 =
      if mode2 == 1 do
        Enum.at(program, position + 2)
      else
        addr = Enum.at(program, position + 2)
        Enum.at(program, addr)
      end

    {arg1, arg2}
  end

  defp two_args_and_addr(program, op, position) do
    mode1 = op |> div(100) |> rem(10)
    mode2 = op |> div(1000) |> rem(100)

    arg1 =
      if mode1 == 1 do
        Enum.at(program, position + 1)
      else
        addr = Enum.at(program, position + 1)
        Enum.at(program, addr)
      end

    arg2 =
      if mode2 == 1 do
        Enum.at(program, position + 2)
      else
        addr = Enum.at(program, position + 2)
        Enum.at(program, addr)
      end

    addr = Enum.at(program, position + 3)

    {arg1, arg2, addr}
  end

  defp one_arg(program, op, position) do
    mode1 = op |> div(100) |> rem(10)

    arg1 =
      if mode1 == 1 do
        Enum.at(program, position + 1)
      else
        addr = Enum.at(program, position + 1)
        Enum.at(program, addr)
      end

    arg1
  end
end
