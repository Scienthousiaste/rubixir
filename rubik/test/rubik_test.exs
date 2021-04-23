defmodule RubikTest do
  use ExUnit.Case

  alias Rubik.Cube
  alias Rubik.Transforms

  test "Applying the left transformation on a solved cube" do
    cube = Cube.new_cube()
    c1 = Transforms.apply(cube, "L")
    assert c1."ULF" == "blu"
    assert c1."ULB" == "bld"
    assert c1."DLB" == "fld"
    assert c1."DLF" == "flu"
    c2 = Transforms.apply(c1, "L")
    assert c2."ULF" == "dlb"
    assert c2."ULB" == "dlf"
    assert c2."DLB" == "ulf"
    assert c2."DLF" == "ulb"
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

end
