defmodule RubikGlobalTest do
  use ExUnit.Case

  @number_iterations 1
  
  defp describe_result(_solved = false, cube, moves, start_time) do
    IO.puts "Failed to solve cube"
    IO.inspect cube
    IO.inspect moves
    { false, Enum.count(moves), Time.diff(Time.utc_now, start_time, :millisecond) }
  end
  defp describe_result(_solved = true, _cube, moves, start_time) do
    { true, Enum.count(moves), Time.diff(Time.utc_now, start_time, :millisecond) }
  end

  defp solve_a_cube() do
    start = Time.utc_now
    %{cube: cube, moves: moves} = Rubik.scrambled_cube
    |> Rubik.solve_cube
    describe_result(Rubik.is_solved?(cube), cube, moves, start)
  end

  @tag timeout: :infinity
  test "Every cube is solved" do
    {all_moves, all_time} = Enum.reduce(
      1..@number_iterations,
      { 0, 0 },
      fn _i, { total_moves, total_time } ->
       {solved, count_moves, time} = solve_a_cube()
       assert solved
       { total_moves + count_moves, total_time + time }
    end)

    IO.puts "Solved #{@number_iterations} cubes, mean move count = #{all_moves / @number_iterations}, mean time = #{all_time / @number_iterations} milliseconds"

  end

end

