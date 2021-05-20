defmodule Rubik.Solver.F2L do

  alias Rubik.Solver.Helpers
  alias Rubik.Solver.AlgoHelpers
  alias Rubik.Cube
  alias Rubik.Solver.F2L.PlaceGoalDuo
  @max_iter_solve_f2l 1

  defp is_not_placed?(cube, cubicle) do
    Map.get(cube, cubicle)
      != Helpers.cubicle_to_expected_cubie(cubicle)
  end

  defp find_next_f2l_goal(solver_data = 
    %{ cube: cube, base_face: face }) do
    goal = Enum.find(
      f2l_cubie_duos(face),
      fn [corner, edge] -> 
        is_not_placed?(cube, corner)
        or is_not_placed?(cube, edge)
      end
    )
    { solver_data, goal }
  end

  def f2l_goal_state(face) do
    Enum.map(f2l_cubies(face),
      fn atom_cubicle ->
        Helpers.cubicle_to_expected_cubie(atom_cubicle)
      end
    )
  end

  defp current_f2l_state(cube, face) do
    Enum.map(f2l_cubies(face),
      fn cubie -> Map.get(cube, cubie) end
    ) 
  end

  defp f2l_completed?(cube, face) do
    current_f2l_state(cube, face) == f2l_goal_state(face)
  end

  def f2l_cubie_duos(face) do
    Enum.map(Cube.corners(face), 
      fn corner -> [corner, get_edge_up_from_corner(corner, face)] end
    )
  end

  defp f2l_cubies(face) do
    List.flatten(f2l_cubie_duos(face))
  end

  defp get_edge_up_from_corner(corner_atom, face_atom) do
    corner = Atom.to_string(corner_atom) 
    face = Atom.to_string(face_atom)
    String.replace(corner, face, "")
    |> String.to_atom
  end

  defp initial_state_corresponds?(%{base_face: face, 
    cube: cube}, goal, initial_state) do
    Enum.all?(
      AlgoHelpers.rotate_initial_state(initial_state, goal, face),
      fn {key, val} ->
        Map.get(cube, key) == val
      end
    )
  end

  defp rotate_moves_if_found(nil, _goal) do
    nil
  end
  defp rotate_moves_if_found(_algo = %{ moves: moves }, goal) do
    AlgoHelpers.rotate_moves(moves, goal)
  end

  defp find_algorithm(solver_data, goal) do
    Enum.find(
      Rubik.F2L.Algorithms.get_f2l_algos(),
      fn algo ->
        initial_state_corresponds?(
          solver_data,
          goal,
          algo.initial_state
        )
      end
    )
    |> rotate_moves_if_found(goal)
  end

  defp apply_algorithm(nil, solver_data, _) do
    IO.inspect "NO ALGO FOUND!"
    solver_data
  end
  defp apply_algorithm(algo, solver_data, goal) do
    IO.inspect ["ALGO FOUND", algo, goal]
    Helpers.update_solver_data(algo, solver_data, goal) 
  end

  def complete_f2l_goal( { solver_data, goal }) do
    #REFACTO ? return {solver_data, other}pour avoir juste un joli pipe
    new_sd = PlaceGoalDuo.place_goal_duo(solver_data, goal)
    
    find_algorithm(new_sd, goal)
    |> apply_algorithm(new_sd, goal)
  end

  defp loop_solve_f2l(solver_data, _, _f2l_complete = true) do
    IO.puts "solve_f2l is done"
    solver_data
  end
  defp loop_solve_f2l(solver_data, _n_iter = 0, _f2l_complete = false) do
    IO.puts "Loop solve f2l failed to finish"
    solver_data
  end
  defp loop_solve_f2l(solver_data_pre, iter, _f2l_complete = false) do
    solver_data = find_next_f2l_goal(solver_data_pre)
    |> complete_f2l_goal

    loop_solve_f2l(solver_data, iter - 1,
      f2l_completed?(solver_data.cube, solver_data.base_face)
    )
  end

  def solve_f2l( solver_data = %{ cube: cube, base_face: face } ) do
    loop_solve_f2l(
      solver_data,
      @max_iter_solve_f2l,
      f2l_completed?(cube, face)
    )
  end

end
