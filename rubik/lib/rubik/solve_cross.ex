defmodule Rubik.SolveCross do
  
  @max_iter_solve_cross 500
  
  def solve_cross( solver_data = %{ cube: cube, base_face: face } ) do
    solver_data
    |> loop_solve_cross(@max_iter_solve_cross, cross_edges_placed?(cube, face))
  end

  defp loop_solve_cross(solver_data, _, _cross_edges_placed = true) do
    solver_data
  end
  defp loop_solve_cross(_, _n_iter = 0, _cross_edges_placed = false) do
    IO.puts "Loop solve cross failed to finish"
    exit(:normal) 
  end
  defp loop_solve_cross(solver_data = %{ cube: c, base_face: f }, iter, false) do
    # Here, find next_move - first define an objective?
    IO.puts "loop solve cross, iter: " <> Integer.to_string(iter)
    loop_solve_cross(solver_data, iter - 1, cross_edges_placed?(c, f))
  end

  defp cross_edges_placed?(cube, face) do
    look_for = Enum.map(Rubik.Solver.edges(face),
      fn atom_edge -> String.downcase(Atom.to_string(atom_edge)) end
    )
    current_edges_state = Enum.map(Rubik.Solver.edges(face),
      fn edge -> Map.get(cube, edge) end
    ) 
    reorder_edges(current_edges_state, List.first(look_for)) == look_for
  end

  defp reorder_edges(edges = [h | _], first_edge) do
    do_reorder(h == first_edge, [], edges, first_edge)
  end

  defp do_reorder(_first_edge_found = true, new_list, edges_rem, _) do
    edges_rem ++ new_list
  end
  defp do_reorder(_first_edge_found = false, new_list, [h | tl], first_edge) do
    do_reorder(h == first_edge, new_list ++ [h], tl, first_edge) 
  end
  defp do_reorder(_first_edge_found = false, _, [], _) do
    []
  end

end
