defmodule Rubik.Solver do
  alias Rubik.Solver.Helpers
  alias Rubik.Cube

  def edges_and_corners(face) do
    %{
      edges: Cube.edges(face),
      corners: Cube.corners(face)
    }
  end

  def is_cubie_in_place?(cubie, cubicle) do
    Helpers.cubicle_to_expected_cubie(cubicle) == cubie
  end

  defp cubies_in_place(cube, cubicles) do
    Enum.count(cubicles, fn cubicle ->
      is_cubie_in_place?(Map.get(cube, cubicle), cubicle)
    end)
  end

  def solve_with(cube, :CFOP) do
    Rubik.Solver.CFOP.solve(cube)
  end

  def solve_cube( cube = %Rubik.State{} ) do
    solve_with(cube, :CFOP) 
  end

end
