defmodule Rubik.CLI do

  def main(args \\ []) do
    args
    |> parse_args(Enum.count(args))
    |> response()
  end

  def exit_with_usage() do
    IO.puts "Rubik accepts a single argument: a string composed of valid Rubik's Cube moves.\nThe accepted moves are quarter turns or half turns of faces only (no slice moves, and no cube rotating).\nSo the 18 accepted moves are: F, L, U, R, D, B, F', L', U', R', D', B', F2, L2, U2, R2, B2, D2. The moves can be separated by spaces.\nThe program returns a sequence of moves that would solve the cube generated by the input sequence of moves to a solved cube."
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
