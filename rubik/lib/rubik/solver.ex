defmodule Rubik.Solver do

  def faces(), do: [:D, :F, :L, :B, :R, :U]

  def edges(:F), do: [:UF, :RF, :DF, :LF] 
  def edges(:L), do: [:UL, :LF, :DL, :LB]
  def edges(:B), do: [:UB, :LB, :DB, :RB]
  def edges(:R), do: [:UR, :RB, :DR, :RF]
  def edges(:U), do: [:UB, :UR, :UF, :UL]
  def edges(:D), do: [:DF, :DR, :DB, :DL]

  def corners(:F), do: [:ULF, :URF, :DRF, :DLF]
  def corners(:L), do: [:ULB, :ULF, :DLF, :DLB]
  def corners(:B), do: [:ULB, :URB, :DRB, :DLB]
  def corners(:R), do: [:URB, :URF, :DRF, :DRB]
  def corners(:U), do: [:ULF, :ULB, :URB, :URF]
  def corners(:D), do: [:DLF, :DLB, :DRB, :DRF]

  def edges_and_corners(face) do
    %{
      edges: edges(face),
      corners: corners(face)
    }
  end

  def is_cubie_in_place?(cubie, cubicle) do
    String.upcase(cubie) == Atom.to_string(cubicle)
  end

  defp cubies_in_place(cube, cubicles) do
    Enum.count(cubicles, fn cubicle ->
      is_cubie_in_place?(Map.get(cube, cubicle), cubicle)
    end)
  end

  defp score_base_face(cube, face) do
    %{ edges: edges, corners: corners } = edges_and_corners(face)
    5 * cubies_in_place(cube, edges) + cubies_in_place(cube, corners)
  end

  defp compute_base_face_scores(cube) do
    Enum.map(faces(),
        fn face -> { face, score_base_face(cube, face) } end
    )
  end

  defp find_cfop_base_face(cube) do
    compute_base_face_scores(cube)
    |> Enum.max_by(fn {_, v} -> v end)
    |> (fn {face, _} -> face end).()
  end

  def solve_cube( cube = %Rubik.State{} ) do
    solve_with(cube, :CFOP) 
  end

  def solve_with(cube, :CFOP) do
    init_cfop_solver_data(cube)
    |> Rubik.SolveCross.solve_cross
    #|> Rubik.SolveF2L.solve_first_two_lines
  end

  defp init_cfop_solver_data(cube) do
     %Rubik.SolverData{
      cube:       cube,
      base_face:  find_cfop_base_face(cube),
      moves:      []
    }
  end

end
