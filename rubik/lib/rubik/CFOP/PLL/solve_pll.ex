defmodule Rubik.Solver.PLL do
  alias Rubik.Solver.Helpers
  alias Rubik.Solver.AlgoHelpers

  defp get_all_algo_moves(algos) do
    for algo <- algos,
        rotation <- AlgoHelpers.get_rotations() do
      AlgoHelpers.rotate_moves(
        algo.moves,
        AlgoHelpers.get_rotate_map(rotation)
      )
    end
  end

  defp moves_opposite_face() do
    Helpers.opposite_face_moves(:D)
  end

  defp only_opposite_face_move() do
    for a <- moves_opposite_face() do
      [a]
    end
  end

  defp one_algo_sequences(algos) do
    algo_moves_sequences = get_all_algo_moves(algos)

    for a <- moves_opposite_face(),
        b <- algo_moves_sequences do
      [a] ++ b
    end
  end

  defp two_algo_sequences(algos) do
    algo_moves_sequences = get_all_algo_moves(algos)

    for a <- moves_opposite_face(),
        b <- algo_moves_sequences,
        c <- moves_opposite_face(),
        d <- algo_moves_sequences do
      [a] ++ b ++ [c] ++ d
    end
  end

  defp make_move_combinations(algos) do
    [[]] ++
      only_opposite_face_move() ++
      get_all_algo_moves(algos) ++
      one_algo_sequences(algos) ++
      two_algo_sequences(algos)
  end

  def find_pll_solution(%{cube: cube}, algos) do
    Enum.find(
      make_move_combinations(algos),
      fn algo_moves ->
        Rubik.Cube.is_solved?(Rubik.Transforms.qturns(cube, algo_moves))
      end
    )
  end

  def apply_pll_algorithm(nil, solver_data) do
    IO.puts("No solution found for PLL")
    IO.inspect(solver_data)
    solver_data
  end

  def apply_pll_algorithm(moves, solver_data) do
    Helpers.update_solver_data(moves, solver_data)
  end

  def solve_pll(solver_data) do
    find_pll_solution(
      solver_data,
      Rubik.PLL.Algorithms.get_pll_algos()
    )
    |> apply_pll_algorithm(solver_data)
  end
end
