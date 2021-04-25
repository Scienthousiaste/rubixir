defmodule Rubik do

  defdelegate new_cube(),                   to: Rubik.Cube
  defdelegate new_cube(sequence),           to: Rubik.Cube
  defdelegate scrambled_cube(),             to: Rubik.Cube
  defdelegate scrambled_cube(number_moves), to: Rubik.Cube
  defdelegate is_solved?(cube),             to: Rubik.Cube

  defdelegate move(cube, move),             to: Rubik.Transforms, as: :qturn 
  defdelegate moves(cube, move_list),       to: Rubik.Transforms, as: :qturns

  defdelegate solve_cube(cube),             to: Rubik.Solver

end
