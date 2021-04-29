defmodule Rubik do

  defdelegate new_cube(),                   to: Rubik.Cube
  defdelegate new_cube(sequence),           to: Rubik.Cube
  defdelegate scrambled_cube(),             to: Rubik.Cube
  defdelegate scrambled_cube(number_moves), to: Rubik.Cube
  defdelegate is_solved?(cube),             to: Rubik.Cube
  defdelegate get_moves(),                  to: Rubik.Cube, as: :moves

  defdelegate qturn(cube, move),             to: Rubik.Transforms
  defdelegate qturns(cube, move_list),       to: Rubik.Transforms

  defdelegate solve_cube(cube),             to: Rubik.Solver

end
