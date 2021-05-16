defmodule Rubik.Solver.F2L do

  alias Rubik.Solver.Helpers
  alias Rubik.Cube
  @max_iter_solve_f2l 1
  
  def solve_f2l( solver_data = %{ cube: cube, base_face: face } ) do
    loop_solve_f2l(
      solver_data,
      @max_iter_solve_f2l,
      f2l_completed?(cube, face)
    )
  end

  defp loop_solve_f2l(solver_data, _, _f2l_complete = true) do
    IO.puts "solve_f2l is done"
    solver_data
  end
  defp loop_solve_f2l(solver_data, _n_iter = 0, _f2l_complete = false) do
    IO.puts "Loop solve f2l failed to finish"
    solver_data
    #exit(:normal)
  end
  defp loop_solve_f2l(solver_data, iter, _f2l_complete = false) do
    find_next_f2l_goal(solver_data)
    solver_data = find_next_f2l_goal(solver_data)
    |> complete_f2l_goal
    loop_solve_f2l(solver_data, iter - 1,
      f2l_completed?(solver_data.cube, solver_data.base_face)
    )
  end

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

  def complete_f2l_goal({ solver_data, _goal }) do
    solver_data
  end

end
