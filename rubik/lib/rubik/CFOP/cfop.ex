defmodule Rubik.Solver.CFOP do

  alias Rubik.Solver
  alias Rubik.Cube

  defp compute_cross_progress(cube, base_face) do
    Enum.filter(Cube.edges(base_face),
      fn edge -> Solver.is_cubie_in_place?(
        Map.get(cube, edge),
        edge
      ) end
    )
  end

  def init_cfop_solver_data(cube) do
    %Rubik.SolverData{
      cube:       cube,
      base_face:  :D,
      moves:      [],
      progress:   compute_cross_progress(cube, :D)
    }
  end
  
  defp get_move_combination(_, 0),    do: []
  defp get_move_combination(base, 1), do: [base]
  defp get_move_combination(base, 2), do: [base <> "2"]
  defp get_move_combination(base, 3), do: [base <> "'"]
  defp get_move_combination(_, 4),    do: []
  defp get_move_combination(base, x), do: get_move_combination(base, x - 4)

  defp move_value_of("2"), do: 2
  defp move_value_of("'"), do: 3

  defp count_move_value(_, 1),    do: 1
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
  
  defp cull_extra_moves(solver_data = %{moves: moves}) do
    IO.puts "Start cull with #{Enum.count moves} moves"
    new_moves = iter_over_moves(moves, [])
    IO.puts "End cull with #{Enum.count new_moves} moves"
    %Rubik.SolverData { solver_data | moves: new_moves }
  end

  def solve(cube) do
    init_cfop_solver_data(cube)
    |> Rubik.Solver.Cross.solve_cross
    |> Rubik.Solver.F2L.solve_f2l
    |> Rubik.Solver.OLL.solve_oll
    |> Rubik.Solver.PLL.solve_pll
    |> cull_extra_moves
  end

end
