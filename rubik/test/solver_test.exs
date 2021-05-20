defmodule RubikSolverTest do
  use ExUnit.Case

  test "With CFOP, the cross on the base_face is solved after cross_solve" do
    #Randomised test
    solver_data = Rubik.Cube.scrambled_cube()
      |> Rubik.Solver.CFOP.init_cfop_solver_data
      |> Rubik.Solver.Cross.solve_cross
    assert Enum.all?(Rubik.Cube.edges(solver_data.base_face), fn edge ->
        String.to_atom(String.upcase(Map.get(solver_data.cube, edge))) == edge
      end
    )
  end

end
