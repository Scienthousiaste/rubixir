defmodule Rubik.Solver.F2L.PlaceGoalDuo do
  alias Rubik.Solver.Helpers

  defp get_move_corner_up(_in_opposite = true, _) do
    []
  end
  defp get_move_corner_up(_, :DLF), do: ["L'", "F"]
  defp get_move_corner_up(_, :DRF), do: ["R", "F'"]
  defp get_move_corner_up(_, :DRB), do: ["R'", "B"]
  defp get_move_corner_up(_, :DLB), do: ["B'", "L"]

  defp move_corner_up(face = :D, corner_cubicle, corner_goal) do
    #TODO: other faces
    get_move_corner_up(
      Helpers.is_in_opposite_face?(corner_cubicle, face),
      corner_cubicle
    )
  end

  defp get_move_edge_up(_in_opposite = true, _) do
    []
  end
  defp get_move_edge_up(_, :LF), do: ["L'", "F"]
  defp get_move_edge_up(_, :RF), do: ["R", "F'"]
  defp get_move_edge_up(_, :RB), do: ["R'", "B"]
  defp get_move_edge_up(_, :LB), do: ["B'", "L"]

  defp move_edge_up(face = :D, edge_cubicle, edge_goal) do
    get_move_edge_up(
      Helpers.is_in_opposite_face?(edge_cubicle, face),
      edge_cubicle
    )
  end

  def find_moves_to_put_in_place(corner_cubicle, edge_cubicle,
    solver_data, goal = [corner_goal, edge_goal]) do
    Rubik.PreAlgo.reach_f2l_pre_algo_state(solver_data, goal,
      move_corner_up(solver_data.base_face, corner_cubicle, corner_goal),
      move_edge_up(solver_data.base_face, edge_cubicle, edge_goal)
    )
  end

  def is_corner_in_its_column?(cube, corner) do
    #TODO: add face in arguments
    opposite_corner = String.to_atom(
      String.replace(Atom.to_string(corner), "D", "U")
    )
    Helpers.is_cubie_permutation?(
      corner, 
      Map.get(cube, corner) 
    )
    or Helpers.is_cubie_permutation?(
      corner,
      Map.get(cube, opposite_corner) 
    )
  end

  def is_edge_in_place_or_top?(cube_struct, edge) do
    #TODO: face
    cube = Map.from_struct(cube_struct)
    Helpers.is_cubie_permutation?(
      edge,
      Map.get(cube, edge)
    )
    or
    (
      Helpers.find_where_target_is(cube, edge)
      |> Atom.to_string
      |> String.contains?("U")
    )
  end
  
  def f2l_algo_state?(cube, goal = [corner, edge], face) do
    pseudo_solver_data = %Rubik.SolverData{
      cube: cube,
      base_face: face,
      moves: [],
      progress: []
    }
    
    f2l_algo_map = Rubik.F2L.Algorithms.get_f2l_algo_map(goal, face)
    Enum.find(
      Rubik.Solver.F2L.initial_conditions_in_cube(pseudo_solver_data, goal),
      fn algo_conditions ->
        Map.get(
          f2l_algo_map,
          Rubik.F2L.Algorithms.key_from_state(algo_conditions)
        )
      end
    ) != nil
  end

  def place_goal_duo(solver_data, goal = [corner, edge]) do
    cube = Map.from_struct(solver_data.cube)
    find_moves_to_put_in_place(
      Helpers.find_where_target_is(cube, corner),
      Helpers.find_where_target_is(cube, edge),
      solver_data,
      goal
    )
    |> Helpers.update_solver_data(solver_data)
  end

end
