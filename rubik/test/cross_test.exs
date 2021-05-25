defmodule RubikCrossTest do
  use ExUnit.Case

  alias Rubik.Solver.Cross.StartingPoint

  test "Selecting the correct cross starting point when 1 cubie in place and 2 would be with a non obvious starting point" do
    cube = Rubik.cube_test(%{
      DL: "dl", 
      DF: "dr",
      DR: "db"
    })

    assert StartingPoint.select_starting_point(cube, :D) == :DF
  end

  test "Selecting a starting point not requiring a rotation in a 2 vs 2 case" do
    cube = Rubik.cube_test(%{
      DL: "dl", 
      DF: "db",
      DR: "dr",
      DB: "df"
    })

    assert StartingPoint.select_starting_point(cube, :D) == :DL
  end 
end
