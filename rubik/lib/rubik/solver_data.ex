defmodule Rubik.SolverData do
  defstruct(
    cube: Rubik.new_cube(),
    base_face: :D,
    moves: [],
    progress: [],
    starting_point: :D
  )
end
