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

  def solve_cube( cube = %Rubik.State{} ) do
    solve_with(cube, :CFOP) 
  end

  def solve_with(cube, :CFOP) do
    init_cfop_solver_data(cube)
    |> Rubik.SolveCross.solve_cross
  end

  defp compute_cross_progress(cube, base_face) do
    Enum.filter(edges(base_face),
      fn edge -> is_cubie_in_place?(Map.get(cube, edge), edge) end
    )
  end

  def init_cfop_solver_data(cube) do
    #base_face = find_cfop_base_face(cube) 
    base_face = :D
    
    %Rubik.SolverData{
      cube:       cube,
      base_face:  base_face,
      moves:      [],
      progress:   compute_cross_progress(cube, base_face)
    }
  end

end
