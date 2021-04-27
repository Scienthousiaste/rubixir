defmodule Rubik.SolveCross do
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
    solver_data = find_next_cross_goal(solver_data) 
    |> complete_cross_goal 

    loop_solve_cross(solver_data, iter - 1, 
      cross_edges_placed?(solver_data.cube, solver_data.base_face)
    )
  end

  defp find_next_cross_goal(solver_data = %{ cube: cube, base_face: face }) do
    goal = Enum.find(
      Enum.zip(cross_goal_state(face), current_state(cube, face)),
      fn { g, c } -> g != c end
    ) 
    { solver_data, goal }
  end

  defp update_solver_data([], solver_data, _) do
    solver_data 
  end
  defp update_solver_data(move_sequence, solver_data, goal) do
    %{ solver_data |
        cube: Rubik.Transforms.qturns(solver_data.cube, move_sequence),
        progress: solver_data.progress ++ [String.to_atom(String.upcase(goal))],
        moves: solver_data.moves ++ solver_data.moves
    }
  end

  defp complete_cross_goal( { solver_data, {goal, _} } ) do
    Rubik.BFS.reach_goal(
      solver_data,
      String.to_atom(String.upcase(goal)),
      @max_moves_per_bfs_search
    )
    |> update_solver_data(solver_data, goal)
  end

  defp cross_goal_state(face) do
    Enum.map(Rubik.Solver.edges(face),
      fn atom_edge -> String.downcase(Atom.to_string(atom_edge)) end
    )
  end

  defp current_state(cube, face) do
    Enum.map(Rubik.Solver.edges(face),
      fn edge -> Map.get(cube, edge) end
    ) 
  end

  defp cross_edges_placed?(cube, face) do
    current_state(cube, face) == cross_goal_state(face)
  end

end
