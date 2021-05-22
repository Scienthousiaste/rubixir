defmodule RubikPowerTest do
  use ExUnit.Case

  @number_iterations 500
  
  defp describe_result(_solved = false, cube, moves, _start_time) do
    IO.puts "Failed to solve cube"
    IO.inspect cube
    IO.inspect moves
    false
  end
  defp describe_result(_solved = true, _cube, moves, start_time) do
    IO.puts "Solved a cube with #{Enum.count moves} moves in #{Time.diff(Time.utc_now, start_time, :millisecond)} milliseconds"
    true
  end

  defp solve_a_cube() do
    start = Time.utc_now
    %{cube: cube, moves: moves} = Rubik.scrambled_cube
    |> Rubik.solve_cube
    describe_result(Rubik.is_solved?(cube), cube, moves, start)
  end

  @tag timeout: :infinity
  test "Every cube is solved" do
    Enum.each(0..@number_iterations, fn _i -> assert solve_a_cube() end)
  end

end

