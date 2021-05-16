defmodule Rubik.Algorithm do
  defstruct(
    step: :undefined,
    initial_state: %{},
    solving: [],
    moves: []
  )
end
