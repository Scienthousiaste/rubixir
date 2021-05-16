
defmodule RubikSolverTest do
  use ExUnit.Case

  alias Rubik.Cube
  alias Rubik.F2L.Algorithms

  test "With CFOP, the cross on the base_face is solved after cross_solve" do
    #Randomised test
    solver_data = Cube.scrambled_cube()
      |> Rubik.Solver.CFOP.init_cfop_solver_data
      |> Rubik.Solver.Cross.solve_cross
    assert Enum.all?(Cube.edges(solver_data.base_face), fn edge ->
        String.to_atom(String.upcase(Map.get(solver_data.cube, edge))) == edge
      end
    )
  end

  test "Testing f2l_cubie_duos - get the correct cubie duos used in F2L" do
    duos_d = MapSet.new(Rubik.Solver.F2L.f2l_cubie_duos(:D))
    expected_duos_d = MapSet.new([
      [:DRF, :RF],
      [:DLF, :LF],
      [:DLB, :LB],
      [:DRB, :RB]
    ])
    duos_f = MapSet.new(Rubik.Solver.F2L.f2l_cubie_duos(:F))
    expected_duos_f = MapSet.new([
      [:URF, :UR],
      [:ULF, :UL],
      [:DRF, :DR],
      [:DLF, :DL]
    ])
    duos_u = MapSet.new(Rubik.Solver.F2L.f2l_cubie_duos(:U))
    expected_duos_u = MapSet.new([
      [:URF, :RF],
      [:URB, :RB],
      [:ULB, :LB],
      [:ULF, :LF]
    ])
    assert MapSet.equal?(duos_f, expected_duos_f)
    assert MapSet.equal?(duos_u, expected_duos_u)
    assert MapSet.equal?(duos_d, expected_duos_d)
  end

  test "Initial state rotations for the algorithms for the 4 goals of F2L. Test rotate_initial_state with face D" do
    algo1_initial_state = %{ URF: "rdf", UB: "fr" }
    initial_state_algo1_expected = %{
      [:DRF, :RF] => %{ URF: "rdf", UB: "fr" },
      [:DLF, :LF] => %{ ULF: "fld", UR: "lf" },
      [:DLB, :LB] => %{ ULB: "ldb", UF: "bl" },
      [:DRB, :RB] => %{ URB: "brd", UL: "rb" },
    }
    Enum.each(
      initial_state_algo1_expected, 
      fn {cubie_duo_to_solve, expected_initial_state} -> 
        assert Rubik.Solver.AlgoHelpers.rotate_initial_state(
          algo1_initial_state, cubie_duo_to_solve, :D
        ) == expected_initial_state
      end 
    )
  end

  test "F2L algos work - they solve what they claim to solve, and don't touch the cross" do
    cross = %{
      DF: "df",
      DR: "dr",
      DL: "dl",
      DB: "db",
    }
    cross_g = [:DF, :DR, :DL, :DB]
    Enum.each(
      Algorithms.get_f2l_algos(),
      fn algo ->
        assert (
        Cube.cube_test(Map.merge(cross, algo.initial_state))
        |> Rubik.qturns(algo.moves)
        |> Rubik.Solver.Helpers.goal_reached?(algo.solving ++ cross_g)
        )
      end
    )
  end
end
