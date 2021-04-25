defmodule Rubik.Solver do

  
  def solve_cube( cube = %Rubik.State{} ) do
    solve_with(cube, :CFOP) 
  end

  def solve_with(cube, :CFOP) do
    init_cfop_solver_data(cube)
    |> solve_cross
  end

  def solve_cross( solver_data = %{ cube: c, base_face: f, moves: m } ) do
    solver_data
  end

  defp init_cfop_solver_data(cube) do
     %Rubik.SolverData{
      cube:       cube,
      base_face:  find_cfop_base_face(cube),
      moves:      []
    }
  end

  def faces(), do: [:D, :F, :L, :B, :R, :U]
  def edges_and_corners(:F) do
    %{
      edges:    [:UF, :RF, :DF, :LF], 
      corners:  [:ULF, :URF, :DRF, :DLF]
    }
  end
  def edges_and_corners(:L) do
    %{
      edges:    [:LB, :UL, :LF, :DL], 
      corners:  [:ULB, :ULF, :DLF, :DLB]
    }
  end
  def edges_and_corners(:B) do
    %{
      edges:    [:UB, :RB, :DB, :LB], 
      corners:  [:ULB, :URB, :DRB, :DLB]
    }
  end
  def edges_and_corners(:R) do
    %{
      edges:    [:RB, :UR, :RF, :DR], 
      corners:  [:URB, :URF, :DRF, :DRB]
    }
  end
  def edges_and_corners(:U) do
    %{
      edges:    [:UF, :UL, :UB, :UR], 
      corners:  [:ULF, :ULB, :URB, :URF]
    }
  end
  def edges_and_corners(:D) do
    %{
      edges:    [:DF, :DL, :DB, :DR], 
      corners:  [:DLF, :DLB, :DRB, :DRF]
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

end
