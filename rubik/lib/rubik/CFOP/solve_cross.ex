defmodule Rubik.Solver.Cross do
  alias Rubik.Solver.Helpers
  @max_iter_solve_cross 5
  @max_moves_per_bfs_search 4
  
  def solve_cross( solver_data = %{ cube: cube, base_face: face } ) do
    loop_solve_cross(
      solver_data,
      @max_iter_solve_cross,
      cross_edges_placed?(cube, face)
    )
  end

  defp loop_solve_cross(solver_data, _, _cross_edges_placed = true) do
    solver_data
  end
  defp loop_solve_cross(_, _n_iter = 0, _cross_edges_placed = false) do
    IO.puts "Loop solve cross failed to finish"
    exit(:normal) 
  end
  defp loop_solve_cross(solver_data, iter, false) do
    sd = find_next_cross_goal(solver_data) 
    |> complete_cross_goal 

    loop_solve_cross(sd, iter - 1, 
      cross_edges_placed?(sd.cube, sd.base_face)
    )
  end

  defp find_next_cross_goal(solver_data = %{ cube: cube, base_face: face }) do
    goal = Enum.find(
      Enum.zip(cross_goal_state(face), current_state(cube, face)),
      fn { g, c } -> g != c end
    ) 
    { solver_data, goal }
  end

  defp complete_cross_goal( { solver_data, {goal, _} } ) do
    Rubik.BFS.reach_goal(
      solver_data,
      String.to_atom(String.upcase(goal)),
      @max_moves_per_bfs_search
    )
    |> Helpers.update_solver_data(solver_data, goal)
  end

  defp cross_goal_state(face) do
    Enum.map(Rubik.Cube.edges(face),
      fn atom_edge -> Helpers.cubicle_to_expected_cubie(atom_edge) end
    )
  end

  defp current_state(cube, face) do
    Enum.map(Rubik.Cube.edges(face),
      fn edge -> Map.get(cube, edge) end
    ) 
  end

  defp cross_edges_placed?(cube, face) do
    current_state(cube, face) == cross_goal_state(face)
  end

end
