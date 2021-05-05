defmodule RubikTest do
  use ExUnit.Case

  alias Rubik.Cube
  alias Rubik.Transforms

  test "Applying the left q-turn on a solved cube" do
    cube = Cube.new_cube()
    c1 = Transforms.qturn(cube, "L")
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
      c1 = Transforms.qturn(cube, transform) 
      assert c1 != cube
      c2 = Transforms.qturn(c1, transform) 
      assert c2 != c1
      c3 = Transforms.qturn(c2, transform) 
      assert c3 != c2
      c4 = Transforms.qturn(c3, transform) 
      assert c4 == cube
    end
  end

  test "Applying all basic q-turns and get the correct state of the cube" do
    cube = Transforms.qturns(Cube.new_cube(),
      ["L", "U", "L", "D", "F", "R", "B", "R"])

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

  test "Double q-turns work as expected" do
    for transform <- ["F", "L", "U", "R", "D", "B"] do 
      cube = Cube.new_cube
      c1 = Transforms.qturn(cube, transform <> "2")
      c2a = Transforms.qturn(cube, transform)
      c2 = Transforms.qturn(c2a, transform)
      assert c1 == c2
    end
  end

  test "Reverse q-turns work as expected" do
    for transform <- ["F", "L", "U", "R", "D", "B"] do 
      cube = Cube.new_cube
      c1 = Transforms.qturn(cube, transform)
      c2 = Transforms.qturn(c1, transform <> "'")
      assert c2 == cube 
    end
  end

  test "All types of moves and back" do
    cube = Cube.new_cube()
    |> Transforms.qturns(["B", "D", "F'", "B'", "D", "L2", "U", "L", "U'", "B",
      "D'", "R", "B", "R", "D'", "R", "L'", "F", "U2", "D"])
    |> Transforms.qturns(Enum.reverse(["B'", "D'", "F", "B", "D'", "L2", "U'",
      "L'", "U", "B'", "D", "R'", "B'", "R'", "D", "R'", "L", "F'", "U2", "D'"]))
    assert cube == Cube.new_cube()
  end

end
