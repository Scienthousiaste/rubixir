defmodule Rubik do

  defdelegate new_cube(),         to: Rubik.Cube
  defdelegate new_cube(sequence), to: Rubik.Cube

#defdelegate scrambled_cube(n), to: Rubik.Cube
  defdelegate solve_cube(cube),   to: Rubik.Solver

end
