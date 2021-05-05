
defmodule RubikSolverTest do
  use ExUnit.Case

  alias Rubik.Cube
  alias Rubik.Solver
  alias Rubik.SolveCross
  alias Rubik.SolveF2L


  test "With CFOP, the cross on the base_face is solved after cross_solve" do
    #Randomised test
    solver_data = Cube.scrambled_cube()
      |> Solver.init_cfop_solver_data
      |> SolveCross.solve_cross
    assert Enum.all?(Solver.edges(solver_data.base_face), fn edge ->
        String.to_atom(String.upcase(Map.get(solver_data.cube, edge))) == edge
      end
    )
  end

  test "Testing f2l_cubie_duos - get the correct cubie duos used in F2L" do
    duos_f = MapSet.new(SolveF2L.f2l_cubie_duos(:F))
    expected_duos_f = MapSet.new([
      [:URF, :UR],
      [:ULF, :UL],
      [:DRF, :DR],
      [:DLF, :DL]
    ])
    duos_u = MapSet.new(SolveF2L.f2l_cubie_duos(:U))
    expected_duos_u = MapSet.new([
      [:URF, :RF],
      [:URB, :RB],
      [:ULB, :LB],
      [:ULF, :LF]
    ])
    assert MapSet.equal?(duos_f, expected_duos_f)
    assert MapSet.equal?(duos_u, expected_duos_u)
  end

  test "Testing f2l_goal_state for F face" do
    # order matters here
    # only test the F2L specific cubies, doesn't test the cross anymore
    goal_f = SolveF2L.f2l_goal_state(:F)
    expected_f = [
      "ulf", "ul", "urf", "ur", "drf", "dr", "dlf", "dl"
    ]
    assert (goal_f == expected_f)
  end

end
