defmodule Rubik.SolverData do
  defstruct(
    cube:       Rubik.new_cube(),
    base_face:  :B,
    moves:      [],
    progress:   []
  )
end
