defmodule RubikScoreTest do
  use ExUnit.Case

  alias Rubik.Solver.Cross.StartingPoint

  test "Correct score for some starting situations" do
    cube =
      Rubik.cube_test(%{
        DL: "dl",
        DF: "db",
        DB: "df"
      })

    assert StartingPoint.compute_score(:id, cube, :D) == 5.0 * 1.1
    assert StartingPoint.compute_score(:hturn, cube, :D) == 10.0
    assert StartingPoint.compute_score(:qturn, cube, :D) == 0.0
    assert StartingPoint.compute_score(:qrturn, cube, :D) == 0.0
  end
end
