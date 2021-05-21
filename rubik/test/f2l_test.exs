defmodule RubikF2LTest do
  use ExUnit.Case

  alias Rubik.Cube
  alias Rubik.F2L.Algorithms
  alias Rubik.Solver.Helpers
  alias Rubik.Solver.F2L.PlaceGoalDuo

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
    cross_goal = [:DF, :DR, :DL, :DB]
    Enum.each(
      Algorithms.get_f2l_algos(),
      fn algo ->
        assert (
        Cube.cube_test(Map.merge(cross, algo.initial_state))
        |> Rubik.qturns(algo.moves)
        |> Helpers.goal_reached?(algo.solving 
          ++ cross_goal)
        )
      end
    )
  end

  test "Solve easy F2L algo" do
    basic_insert_1_position = %{
      DF: "df",
      DR: "dr",
      DL: "dl",
      DB: "db",
      URB: "brd",
      UL: "rb"
    }

    goal = [:DF, :DR, :DL, :DB, :DRB, :RB]
    solver_data = %Rubik.SolverData{
      cube: Rubik.cube_test(basic_insert_1_position), 
      base_face: :D,
      moves: [],
      progress: [],      
    }
    
    result = Rubik.Solver.F2L.complete_f2l_goal(
      { solver_data, [:DRB, :RB] }
    )
    assert Helpers.goal_reached?(result.cube, goal)
  end

  test "Testing is_corner_in_its_column?" do
    cube = Rubik.cube_test(%{DRF: "rfd", ULB: "lbd", ULF: "dlf"})
    assert PlaceGoalDuo.is_corner_in_its_column?(cube, :DRF)
    assert PlaceGoalDuo.is_corner_in_its_column?(cube, :DLB)
    assert PlaceGoalDuo.is_corner_in_its_column?(cube, :DLF)
    assert (not PlaceGoalDuo.is_corner_in_its_column?(cube, :DRB))
  end


  test "Test placing goal duo when both cubies are on top" do
    cube_dlf = Rubik.cube_test(%{
      DF: "df", DR: "dr", DL: "dl", DB: "db", 
      UR: "lf", URF: "lfd"
    })
    cube_dlf_placed = Rubik.cube_test(%{
      DF: "df", DR: "dr", DL: "dl", DB: "db", 
      UR: "lf", ULF: "lfd"
    })
    cube_drb = Rubik.cube_test(%{
      DF: "df", DR: "dr", DL: "dl", DB: "db", 
      UR: "rb", ULF: "drb"
    })
    
    assert Rubik.PreAlgo.reach_f2l_pre_algo_state(%{cube: cube_dlf_placed, base_face: :D}, [:DLF, :LF], [], []) == []
    assert Rubik.PreAlgo.reach_f2l_pre_algo_state(%{cube: cube_dlf, base_face: :D}, [:DLF, :LF], [], []) == ["U"] 
    assert Rubik.PreAlgo.reach_f2l_pre_algo_state(%{cube: cube_drb, base_face: :D}, [:DRB, :RB], [], []) == ["U2"] 
  end

  test "Testing f2l_algo_state?" do
    cube = Rubik.cube_test(%{
      URB: "rdb", UF: "rb",
      ULB: "dbl", RF: "bl",
      DLF: "dlf", LF: "fl",
      DRF: "drf", UB: "rf",
    })

    assert PlaceGoalDuo.f2l_algo_state?(cube, [:DRB, :RB], :D)
    assert (not PlaceGoalDuo.f2l_algo_state?(cube, [:DLB, :LB], :D))
    assert PlaceGoalDuo.f2l_algo_state?(cube, [:DLF, :LF], :D)
    assert (not PlaceGoalDuo.f2l_algo_state?(cube, [:DRF, :RF], :D))
  end


end
