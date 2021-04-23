defmodule RubikTest do
  use ExUnit.Case

  alias Rubik.Cube
  alias Rubik.Transforms

  test "Applying the left transformation on a solved cube" do
    cube = Cube.new_cube()
    c1 = Transforms.apply(cube, "L")
    assert c1."ULF" == "blu"
    assert c1."LF"  == "lu"
    assert c1."ULB" == "bld"
    assert c1."DL"  == "fl"
    assert c1."DLB" == "fld"
    assert c1."LB"  == "ld"
    assert c1."DLF" == "flu"
    assert c1."UL"  == "bl"
  end

  test "4 identical q-turns get back to initial state" do
    for transform <- ["F", "L", "U", "R", "D", "B"] do 
      cube = Cube.new_cube()
      c1 = Transforms.apply(cube, transform) 
      assert c1 != cube
      c2 = Transforms.apply(c1, transform) 
      assert c2 != c1
      c3 = Transforms.apply(c2, transform) 
      assert c3 != c2
      c4 = Transforms.apply(c3, transform) 
      assert c4 == cube
    end
  end

  test "Applying all basic transformations and get the correct state of the cube" do
    cube = Enum.reduce(["L", "U", "L", "D", "F", "R", "B", "R"], Cube.new_cube(),
      fn transformation, cube -> Rubik.Transforms.apply(cube, transformation) end
    )

    assert cube == %Rubik.State{
      URF: "dfr",
      URB: "bur", 
      ULB: "lbu", 
      ULF: "ful", 
      DRF: "rdb",
      DRB: "bld", 
      DLB: "ldf", 
      DLF: "urf", 
      UR:   "df",
      UB:   "bu",
      UL:   "dl",
      UF:   "fu",
      DR:   "rd",
      DB:   "lf",
      DL:   "db",
      DF:   "rf",
      LF:   "ul",
      LB:   "bl",
      RF:   "rb",
      RB:   "ur"
    }
  end

end
