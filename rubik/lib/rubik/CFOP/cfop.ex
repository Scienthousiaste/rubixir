defmodule Rubik.Solver.CFOP do

  alias Rubik.Solver
  alias Rubik.Cube

  defp compute_cross_progress(cube, base_face) do
    Enum.filter(Cube.edges(base_face),
      fn edge -> Solver.is_cubie_in_place?(
        Map.get(cube, edge),
        edge
      ) end
    )
  end

  def init_cfop_solver_data(cube) do
    base_face = :D
    %Rubik.SolverData{
      cube:       cube,
      base_face:  base_face,
      moves:      [],
      progress:   compute_cross_progress(cube, base_face)
    }
  end

  def solve(cube) do
    init_cfop_solver_data(cube)
    |> Rubik.Solver.Cross.solve_cross
    |> Rubik.Solver.F2L.solve_f2l
#   |> Rubik.Solver.OLL.solve_oll
#   |> Rubik.Solver.PLL.solve_pll
  end

end
