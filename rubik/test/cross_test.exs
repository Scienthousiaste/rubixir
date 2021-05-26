defmodule RubikCrossTest do
  use ExUnit.Case

  alias Rubik.Solver.Cross.StartingPoint

  test "Selecting the correct cross starting point when 1 cubie in place and 2 would be with a non obvious starting point" do
    cube = Rubik.cube_test(%{
      DL: "dl", 
      DF: "dr",
      DR: "db"
    })
    assert StartingPoint.select_starting_point(cube, :D) == :DB
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

  test "Correctly choosing DR" do
    cube = Rubik.cube_test(%{
      DB: "df", 
    })
    assert StartingPoint.select_starting_point(cube, :D) == :DR
  end 

  test "Correctly choosing DF" do
    cube = Rubik.cube_test(%{
      DR: "df"
    })
    assert StartingPoint.select_starting_point(cube, :D) == :DF
  end 

  test "Choosing DL when 1 vs 1" do
    cube = Rubik.cube_test(%{
      DR: "df",
      DB: "db"
    })
    assert StartingPoint.select_starting_point(cube, :D) == :DL
  end 

end
