defmodule Rubik.Solver.PLL do
 
  alias Rubik.Solver.Helpers 

  defp initial_state_corresponds?(initial_state, cube) do
    Enum.all?(
      initial_state,
      fn { cubicle, cubie } ->
        Map.get(
          cube,
          cubicle
        ) == cubie
      end
    )
  end


  defp return_moves_if_exist(nil), do: nil
  defp return_moves_if_exist(algo), do: algo.moves


  defp find_pll_algorithm(solver_data = %{cube: cube, base_face: face},
    algo_list) do
    
    algo = Enum.find(
      algo_list,
      fn algo ->
        initial_state_corresponds?(algo.initial_state, cube) 
      end
    )
    {return_moves_if_exist(algo), solver_data}
  end

  defp apply_pll_algorithm({nil, solver_data}) do
    IO.puts "Couln't solve PLL, no corresponding algo found"
    solver_data
  end
  defp apply_pll_algorithm({moves, solver_data}) do
    Helpers.update_solver_data(moves, solver_data)
  end

  def solve_pll( solver_data ) do
    IO.puts "In solve_pll"
    IO.inspect solver_data
    
    find_pll_algorithm(solver_data, Rubik.PLL.Algorithms.get_pll_algos())
    |> apply_pll_algorithm
  end

end

