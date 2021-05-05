defmodule Rubik.SolveF2L do
  alias Rubik.Solver.Helpers
  @max_iter_solve_f2l 1
  
  def solve_f2l( solver_data = %{ cube: cube, base_face: face } ) do
    loop_solve_f2l(
      solver_data,
      @max_iter_solve_f2l,
      f2l_completed?(cube, face)
    )
  end

  defp loop_solve_f2l(solver_data, _, _f2l_complete = true) do
    IO.puts "solve_f2l is done, solver_data"
    IO.inspect solver_data
    solver_data
  end
  defp loop_solve_f2l(_, _n_iter = 0, _f2l_complete = false) do
    IO.puts "Loop solve f2l failed to finish"
    exit(:normal)
  end
  defp loop_solve_f2l(solver_data, iter, _f2l_complete = false) do
    solver_data = find_next_f2l_goal(solver_data)
    |> complete_f2l_goal

    loop_solve_f2l(solver_data, iter - 1,
      f2l_completed?(solver_data.cube, solver_data.base_face)
    )
  end

  defp find_next_f2l_goal(solver_data = %{ cube: cube, base_face: face }) do
    # TODO: optimise to get the smaller move count
    # instead of the first available
    goal = Enum.find(
      f2l_cubie_duos(face),
      fn [corner, edge] -> 
        (Map.get(cube, corner) != Helpers.cubicle_to_expected_cubie(corner))
        or (Map.get(cube, edge) != Helpers.cubicle_to_expected_cubie(edge))
      end
    )
    IO.inspect goal
    { solver_data, goal }
  end

  defp apply_algo(_algo = nil, _solver_data) do
    nil
  end
  defp apply_algo(algo, solver_data) do
    IO.puts "algo found"
    IO.inspect algo
    solver_data
  end

  def find_corresponding_algo(cube, face, corner_cubicle, edge_cubicle) do
     
    #NEED TO FIND WAY TO DIFFERENTIATE:
    # les 2 URF_UB, les 2 URF_UR
    # dif entre les 2 URF_UR : c'est le EDGE
    # REGLE : si quand je fais le scrit sur un cube neuf le edge est pas
    # bon, je reverse. Sauf que ça veut rien dire et marchait que pour un truc :(


    # REGLE pour les corner : 
    # Que les regles. si pattern 1, URF, si pattern 2, FUR
  
    %{
      FUR_UR: ["U", "R", "U'", "R'"],
      FUR_UF: ["U'", "F'", "U", "F"], 
      ULB_UB: ["R'", "U", "R"],
      URF_UB: ["R", "U", "R'"],


# case 1
      URF_BU: ["U'", "R", "U'", "R'", "U", "F'", "U'", "F"],
      URF_UL: ["U'", "R", "U", "R'", "U", "R", "U", "R'"],
      URF_RU: ["U'", "R", "U2", "R'", "U", "F'", "U'", "F"],
      URF_UF: ["R'", "U2", "R2", "U", "R2", "U", "R"], 
      URB_UR: ["U", "R'", "U", "R", "U'", "R'", "U'", "R"],
      URF_UR: ["U'", "R", "U'", "R'", "U", "R", "U", "R'"],

# case 2
      FUR_UB: ["U'", "R", "U", "R'", "U2", "R", "U'", "R'"],
      FUR_UL: ["U'", "R", "U2", "R'", "U2", "R", "U'", "R'"],
      FUR_UL: ["U", "F'", "U'", "F", "U2", "F'", "U", "F"],
      FUR_UB: ["U", "F'", "U2", "F", "U2", "F'", "U", "F"],

# case 3
      RFU_UB: ["U", "R", "U2", "R'", "U", "R", "U'", "R'"],
      RFU_UL: ["U'", "F'", "U2", "F", "U'", "F'", "U", "F"],
      RFU_LU: ["R", "U'", "R'", "U2", "R", "U", "R'"],
      RFU_UB: ["F'", "L'", "U2", "L", "F"],


# A reverif en comparant aux transfo d'au dessus
# y'a juste la 1 et la 2 qui coincident pas
# edge pas check
      FUR_UF: ["F'", "U", "F", "U2", "R", "U", "R'"],
      URF_UR: ["R", "U'", "R'", "U2", "F'", "U'", "F"],
      RFU_UR: ["R", "U2", "R'", "U'", "R", "U", "R'"],
      RFU_UF: ["F'", "U2", "F", "U", "F'", "U'", "F"],
      RFU_FU: ["R", "U", "R'", "U2", "R", "U", "R'", "U'", "R", "U", "R'"],
      RFU_UR: ["F", "U", "R", "U'", "R'", "F'", "R", "U'", "R'"],


      DRF_UR: ["R'", "F'", "R", "U", "R", "U'", "R'", "F"],
      DRF_UF: ["U", "R", "U'", "R'", "U'", "F'", "U", "F"],
      FDR_UR: ["R", "U'", "R'", "U", "R", "U'", "R'"],
      RFD_UF: ["F'", "U", "F", "U'", "F'", "U", "F"],
      FDR_UF: ["F'", "U'", "F", "U", "F'", "U'", "F"],
      RFD_UR: ["R", "U", "R'", "U'", "R", "U", "R'"],


      RFU_FR: ["R", "U'", "R'", "U", "F'", "U", "F"],
      RFU_RF: ["U", "R", "U'", "R'", "U", "R", "U'", "R'", "U", "R", "U'", "R'"],
      FUR_RF: ["U'", "R", "U'", "R'", "U2", "R", "U'", "R'"],
      URF_RF: ["U", "R", "U", "R'", "U2", "R", "U", "R'"],
      FUR_FR: ["U'", "R", "U", "R'", "U", "F'", "U'", "F"],
      URF_FR: ["U", "F'", "U'", "F", "U'", "R", "U", "R'"],








    }
    nil
  end

  defp solve_with_f2l_algo(
    solver_data = %{face: face, cube: cube},
    goal = [corner, edge]) do

    IO.puts "in solve with f2l algo, goal, solver_data"
    IO.inspect goal
    find_corresponding_algo(cube, face, 
      Helpers.find_where_target_is(cube, corner),
      Helpers.find_where_target_is(cube, edge),
    )
    |> apply_algo(solver_data)

    solver_data
  end

  defp update_solver_data(solver_data, goal) do
    solver_data
  end

  defp complete_f2l_goal( { solver_data, goal } ) do 
    solve_with_f2l_algo(solver_data, goal)
    |> update_solver_data(goal)
  end

  def f2l_goal_state(face) do
    Enum.map(f2l_cubies(face),
      fn atom_cubicle -> Helpers.cubicle_to_expected_cubie(atom_cubicle) end
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
    Enum.map(Rubik.Solver.corners(face), 
      fn corner -> [corner, remove_face_from_corner(corner, face)] end
    )
  end

  defp remove_face_from_corner(corner_atom, face_atom) do
    corner = Atom.to_string(corner_atom) 
    face = Atom.to_string(face_atom)
    String.replace(corner, face, "")
    |> String.to_atom
  end

  defp f2l_cubies(face) do
    List.flatten(f2l_cubie_duos(face))
  end

end
