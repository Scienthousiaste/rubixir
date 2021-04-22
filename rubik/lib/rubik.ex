defmodule Rubik do

  defdelegate new_cube(),         to: Rubik.Cube
  defdelegate new_cube(sequence), to: Rubik.Cube

end
