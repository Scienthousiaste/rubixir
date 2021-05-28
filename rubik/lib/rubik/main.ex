defmodule Rubik.CLI do

  def main(args \\ []) do
    args
    |> parse_args(Enum.count(args))
    |> response()
  end

  def exit_with_usage() do
    IO.puts "Rubik accepts a single argument: a string composed of valid Rubik's Cube moves (= which are among the 18: F, L, U, R, D, B, F', L', U', R', D', B', F2, L2, U2, R2, B2, D2), that can separated by spaces." 
    exit(:normal)
  end

  def parse_args([], _) do
    exit_with_usage()
  end
  def parse_args([move_sequence], _num_args = 1) do
    move_sequence
    |> Rubik.new_cube
    |> Rubik.solve_cube
  end
  def parse_args(_args, _) do
    exit_with_usage()
  end

  defp response(_solver_data = %{moves: moves}) do
    IO.puts Enum.join(moves, " ")
  end
end
