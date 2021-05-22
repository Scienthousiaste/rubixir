defmodule Rubik.Solver.PLL do
 
  alias Rubik.Solver.Helpers 
  alias Rubik.Solver.AlgoHelpers 

  defp initial_state_corresponds?(initial_state, cube) do
    Enum.all?(
      initial_state,
      fn { cubicle, cubie } ->
        Map.get(cube, cubicle) == cubie
      end
    )
  end

  defp solves_cube?(moves, cube) do
    Rubik.Transforms.qturns(cube, moves)
    |> Rubik.Cube.is_solved?
  end


  defp rotate_pll_moves_if_found(nil, _), do: nil
  defp rotate_pll_moves_if_found(%{moves: moves}, rotate_map) do
    AlgoHelpers.rotate_moves(moves, rotate_map)
  end
  
  defp return_moves_if_exist_or_keep_searching(nil, 
    solver_data = %{ cube: cube, base_face: face }, algo_list) do

    res = Enum.find_value(
      AlgoHelpers.get_rotations(),
      fn rotation ->
        rotate_map = AlgoHelpers.get_rotate_map(rotation)
        Enum.find(
          Rubik.PLL.Algorithms.get_pll_algos(),
          fn algo ->

            solves_cube?(
              AlgoHelpers.rotate_moves(algo.moves, rotate_map),
              Map.from_struct(cube)
            )

            #initial_state_corresponds?(
            #  AlgoHelpers.rotate_initial_state_pll(
            #    algo.initial_state, rotate_map
            #  ),
            #  cube
            #)
          end
        )
        |> rotate_pll_moves_if_found(rotate_map)
      end
    )

    IO.inspect ["in return_moves_keep_searching, res", res]
    {res, solver_data}
  end
  defp return_moves_if_exist_or_keep_searching(algo, solver_data, _) do
    {algo.moves, solver_data}
  end


  defp find_pll_algorithm(solver_data = %{cube: cube, base_face: face},
    algo_list) do

    algo = Enum.find(
      algo_list,
      fn algo ->
        #initial_state_corresponds?(algo.initial_state, cube) 
        solves_cube?(algo.moves, cube)
      end
    )
    return_moves_if_exist_or_keep_searching(algo, solver_data, algo_list)
  end

 # defp apply_pll_algorithm({nil, solver_data}) do
 #   IO.puts "Couln't solve PLL, no corresponding algo found"
 #   solver_data
 # end
 # defp apply_pll_algorithm({moves, solver_data}) do
 #   Helpers.update_solver_data(moves, solver_data)
 # end





  def get_all_algo_moves(algos) do
    for algo <- algos,
        rotation <- AlgoHelpers.get_rotations() do
        AlgoHelpers.rotate_moves(
          algo.moves,
          AlgoHelpers.get_rotate_map(rotation)
        )
    end
  end

  #def find_pll_solution(solver_data = %{cube: cube,
  #  base_face: face}, algos) do
  #

  def make_choices(algos) do
    m = [] ++ Helpers.opposite_face_moves(:D)
    m_algos = [] ++ get_all_algo_moves(algos)

    for a <- m,
        b <- m_algos,
        c <- m,
        d <- m_algos,
        e <- m do
        [a] ++ b ++ [c] ++ d ++ [e]
    end
  end

  def find_pll_solution(%{cube: cube}, algos) do
      
    Enum.find(
      make_choices(algos),
      fn algo_moves ->
        Rubik.Cube.is_solved?(
          Rubik.Transforms.qturns(cube, algo_moves)
        )
      end
    )
  end

  def apply_pll_algorithm(nil, sd) do
    IO.puts "No solution found for PLL"
  end
  def apply_pll_algorithm(moves, sd) do
    Helpers.update_solver_data(moves, sd)
  end

  def solve_pll( solver_data ) do
    IO.puts "In solve_pll"
    IO.inspect solver_data
    
    algo_moves_pll = find_pll_solution(solver_data, Rubik.PLL.Algorithms.get_pll_algos())
   
    IO.puts "result find_pll_algorithm:"
    IO.inspect algo_moves_pll
    
    apply_pll_algorithm(algo_moves_pll, solver_data)
  end




end

