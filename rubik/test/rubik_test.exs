defmodule RubikTest do
  use ExUnit.Case

  alias Rubik.Cube
  alias Rubik.Transforms

  test "4 identical q-turns get back to initial state" do
    cube = Cube.new_cube()
    c1 = Transforms.apply(cube, "R") 
    assert c1 != cube
    c2 = Transforms.apply(c1, "R") 
    assert c2 != c1
    c3 = Transforms.apply(c2, "R") 
    assert c3 != c2
    c4 = Transforms.apply(c3, "R") 
    assert c4 == cube
  end

end
