defmodule Rubik.Solver.F2L do

  alias Rubik.Solver.Helpers
  alias Rubik.Solver.AlgoHelpers
  alias Rubik.Cube
  alias Rubik.Solver.F2L.PlaceGoalDuo
  alias Rubik.F2L.Algorithms
  @max_iter_solve_f2l 4

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

  def f2l_completed?(cube, face) do
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

  def initial_conditions_in_cube(
    %{ cube: cube },
    [goal_corner, goal_edge]) do

    Enum.map(
      Algorithms.get_algo_initial_cubicles(),
      fn [corner, edge] -> 
        
        { rotated_corner, _, _ } =
          AlgoHelpers.rotate_f2l_cubicle(corner, goal_corner)
        map_with_corner = Map.put(%{},
          rotated_corner,
          Map.get(cube, rotated_corner)
        )
        
        { rotated_edge, _, _ } =
          AlgoHelpers.rotate_f2l_cubicle(edge, goal_edge)
        Map.put(
          map_with_corner,
          rotated_edge,
          Map.get(cube, rotated_edge)
        )
      end
    )
  end

  defp return_algo_moves_or_nil(nil) do
    nil
  end
  defp return_algo_moves_or_nil(algo) do
    algo.moves
  end
  def find_algorithm(solver_data = %{ base_face: face }, goal) do
    f2l_algo_map = Algorithms.get_f2l_algo_map(goal, face)
    algo = Enum.find_value(
      initial_conditions_in_cube(solver_data, goal),
      fn algo_conditions ->
         Map.get(
          f2l_algo_map,
          Algorithms.key_from_state(algo_conditions)
        )
      end
    )
    return_algo_moves_or_nil(algo)
  end

  defp apply_algorithm(nil, solver_data, _) do
    solver_data
  end
  defp apply_algorithm(algo, solver_data, goal) do
    Helpers.update_solver_data(algo, solver_data, goal) 
  end

  def complete_f2l_goal( { solver_data, goal }) do
    duo_in_place_solver_data = PlaceGoalDuo.place_goal_duo(solver_data, goal)

    find_algorithm(duo_in_place_solver_data, goal)
    |> apply_algorithm(duo_in_place_solver_data, goal)
  end

  defp loop_solve_f2l(solver_data, _, _f2l_complete = true) do
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
