defmodule AdventOfCode.Day07 do
  def part1(program) do
    # 0..4
    # |> Enum.to_list()
    # |> permutations
    # |> Enum.map(fn settings ->
    #   output =
    #     settings
    #     |> Enum.reduce(0, fn setting, output ->
    #       {:exit, [output]} = process(program, [setting, output])

    #       output
    #     end)

    #   {settings, output}
    # end)
    # |> Enum.max_by(fn {_settings, val} -> val end)
  end

  def part2(program) do
    5..9
    |> Enum.to_list()
    |> permutations
    |> Enum.map(fn settings -> run(settings, program) end)
    |> Enum.map(fn outputs ->
      outputs
      |> Enum.at(4)
      |> Enum.reverse()
      |> hd
    end)
    |> Enum.max()

    # |> Enum.max_by(fn {_settings, val} -> val end)
  end

  defp run(settings, program) do
    Agent.start(
      fn ->
        [
          [Enum.at(settings, 1)],
          [Enum.at(settings, 2)],
          [Enum.at(settings, 3)],
          [Enum.at(settings, 4)],
          [Enum.at(settings, 0), 0]
        ]
      end,
      name: __MODULE__
    )

    output =
      0..4
      |> Enum.map(fn ampl_pos ->
        Task.async(fn -> process(program, 0, ampl_pos, []) end)
      end)
      |> Enum.map(&Task.await/1)

    Agent.stop(__MODULE__)

    output
  end

  defp process(program, program_counter, ampl_pos, outputs) do
    # get op_line

    op = program |> Enum.at(program_counter)

    op
    |> rem(100)
    |> case do
      1 ->
        {arg1, arg2, addr} = two_args_and_addr(program, op, program_counter)

        program
        |> List.replace_at(addr, arg1 + arg2)
        |> process(program_counter + 4, ampl_pos, outputs)

      2 ->
        {arg1, arg2, addr} = two_args_and_addr(program, op, program_counter)

        program
        |> List.replace_at(addr, arg1 * arg2)
        |> process(program_counter + 4, ampl_pos, outputs)

      # read from stdin
      3 ->
        addr = Enum.at(program, program_counter + 1)

        input = get_input(ampl_pos)

        program
        |> List.replace_at(addr, input)
        |> process(program_counter + 2, ampl_pos, outputs)

      # write to stdout
      4 ->
        arg = one_arg(program, op, program_counter)

        Agent.update(__MODULE__, fn state ->
          List.update_at(state, ampl_pos, fn outputs -> outputs ++ [arg] end)
        end)

        program
        |> process(program_counter + 2, ampl_pos, [arg | outputs])

      5 ->
        {arg1, arg2} = two_args(program, op, program_counter)

        if arg1 != 0 do
          process(program, arg2, ampl_pos, outputs)
        else
          process(program, program_counter + 3, ampl_pos, outputs)
        end

      6 ->
        {arg1, arg2} = two_args(program, op, program_counter)

        if arg1 == 0 do
          process(program, arg2, ampl_pos, outputs)
        else
          process(program, program_counter + 3, ampl_pos, outputs)
        end

      7 ->
        {arg1, arg2, addr} = two_args_and_addr(program, op, program_counter)

        val = if arg1 < arg2, do: 1, else: 0

        program
        |> List.replace_at(addr, val)
        |> process(program_counter + 4, ampl_pos, outputs)

      8 ->
        {arg1, arg2, addr} = two_args_and_addr(program, op, program_counter)

        val = if arg1 == arg2, do: 1, else: 0

        program
        |> List.replace_at(addr, val)
        |> process(program_counter + 4, ampl_pos, outputs)

      99 ->
        outputs
    end
  end

  defp two_args(program, op, program_counter) do
    mode1 = op |> div(100) |> rem(10)
    mode2 = op |> div(1000) |> rem(100)

    arg1 =
      if mode1 == 1 do
        Enum.at(program, program_counter + 1)
      else
        addr = Enum.at(program, program_counter + 1)
        Enum.at(program, addr)
      end

    arg2 =
      if mode2 == 1 do
        Enum.at(program, program_counter + 2)
      else
        addr = Enum.at(program, program_counter + 2)
        Enum.at(program, addr)
      end

    {arg1, arg2}
  end

  defp two_args_and_addr(program, op, program_counter) do
    mode1 = op |> div(100) |> rem(10)
    mode2 = op |> div(1000) |> rem(100)

    arg1 =
      if mode1 == 1 do
        Enum.at(program, program_counter + 1)
      else
        addr = Enum.at(program, program_counter + 1)
        Enum.at(program, addr)
      end

    arg2 =
      if mode2 == 1 do
        Enum.at(program, program_counter + 2)
      else
        addr = Enum.at(program, program_counter + 2)
        Enum.at(program, addr)
      end

    addr = Enum.at(program, program_counter + 3)

    {arg1, arg2, addr}
  end

  defp one_arg(program, op, program_counter) do
    mode1 = op |> div(100) |> rem(10)

    arg1 =
      if mode1 == 1 do
        Enum.at(program, program_counter + 1)
      else
        addr = Enum.at(program, program_counter + 1)
        Enum.at(program, addr)
      end

    arg1
  end

  def permutations([]) do
    [[]]
  end

  def permutations(list) do
    for h <- list, t <- permutations(list -- [h]), do: [h | t]
  end

  defp get_input(ampl_pos) do
    pos = Integer.mod(ampl_pos - 1, 5)

    Agent.get(__MODULE__, fn state ->
      state
      |> Enum.at(pos)
    end)
    |> case do
      [] ->
        # busy poll ftw!
        get_input(ampl_pos)

      [val | _rest] ->
        Agent.get_and_update(__MODULE__, fn state ->
          updated =
            state
            |> List.update_at(pos, fn [^val | rest] -> rest end)

          {val, updated}
        end)
    end
  end
end
