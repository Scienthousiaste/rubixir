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

  def solve_with(cube, :CFOP) do
    Rubik.Solver.CFOP.solve(cube)
  end

  def solve_cube( cube = %Rubik.State{} ) do
    solve_with(cube, :CFOP) 
  end
  
  def solve_cross( cube = %Rubik.State{} ) do
    Rubik.Solver.CFOP.init_cfop_solver_data(cube)
    |> Rubik.Solver.Cross.solve_cross
    |> Rubik.Solver.CFOP.cull_redundant_moves
  end 
    
  def solve_f2l( cube = %Rubik.State{} ) do
    Rubik.Solver.CFOP.init_cfop_solver_data(cube)
    |> Rubik.Solver.Cross.solve_cross
    |> Rubik.Solver.F2L.solve_f2l
    |> Rubik.Solver.CFOP.cull_redundant_moves
  end 

  def solve_oll( cube = %Rubik.State{} ) do
    Rubik.Solver.CFOP.init_cfop_solver_data(cube)
    |> Rubik.Solver.Cross.solve_cross
    |> Rubik.Solver.F2L.solve_f2l
    |> Rubik.Solver.OLL.solve_oll
    |> Rubik.Solver.CFOP.cull_redundant_moves
  end 

end
