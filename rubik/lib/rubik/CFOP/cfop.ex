defmodule Rubik.Solver.CFOP do
  alias Rubik.Solver.Cross.StartingPoint
  alias Rubik.Solver.Cross

  def init_cfop_solver_data(cube) do
    base_face = :D
    starting_point = StartingPoint.select_starting_point(cube, base_face)

    progress =
      Cross.compute_cross_progress(
        cube,
        base_face,
        starting_point
      )

    %Rubik.SolverData{
      cube: cube,
      base_face: base_face,
      moves: [],
      progress: progress,
      starting_point: starting_point
    }
  end

  defp get_move_combination(_, 0), do: []
  defp get_move_combination(base, 1), do: [base]
  defp get_move_combination(base, 2), do: [base <> "2"]
  defp get_move_combination(base, 3), do: [base <> "'"]
  defp get_move_combination(_, 4), do: []
  defp get_move_combination(base, x), do: get_move_combination(base, x - 4)

  defp move_value_of("2"), do: 2
  defp move_value_of("'"), do: 3

  defp count_move_value(_, 1), do: 1
  defp count_move_value(move, 2), do: move_value_of(String.at(move, 1))

  defp combine_moves(move1, move2) do
    get_move_combination(
      String.at(move1, 0),
      count_move_value(move1, String.length(move1)) +
        count_move_value(move2, String.length(move2))
    )
  end

  defp same_base?(m1, m2), do: String.at(m1, 0) == String.at(m2, 0)

  defp rec_iter_over_moves(_same = true, [move1, move2 | tail], new_list) do
    iter_over_moves(combine_moves(move1, move2) ++ tail, new_list)
  end

  defp rec_iter_over_moves(_same = false, [move1, move2 | tail], new_list) do
    iter_over_moves([move2 | tail], new_list ++ [move1])
  end

  defp iter_over_moves(untreated = [move1, move2 | _tail], new_list) do
    rec_iter_over_moves(same_base?(move1, move2), untreated, new_list)
  end

  defp iter_over_moves([move | []], new_list), do: new_list ++ [move]
  defp iter_over_moves([], new_list), do: new_list

  defp rec_cull_redundant_moves(_changes = true, solver_data) do
    cull_redundant_moves(solver_data)
  end

  defp rec_cull_redundant_moves(_changes = false, solver_data) do
    solver_data
  end

  def cull_redundant_moves(solver_data = %{moves: moves}) do
    new_moves = iter_over_moves(moves, [])

    rec_cull_redundant_moves(
      Enum.count(new_moves) < Enum.count(moves),
      %Rubik.SolverData{solver_data | moves: new_moves}
    )
  end

  def solve(cube) do
    init_cfop_solver_data(cube)
    |> Rubik.Solver.Cross.solve_cross()
    |> Rubik.Solver.F2L.solve_f2l()
    |> Rubik.Solver.OLL.solve_oll()
    |> Rubik.Solver.PLL.solve_pll()
    |> cull_redundant_moves
  end
end
