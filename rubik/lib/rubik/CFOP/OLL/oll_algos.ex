defmodule Rubik.OLL.Algorithms do
  
  alias Rubik.Algorithm
  alias Rubik.Solver.AlgoHelpers

  def make_oll_algo(initial_state, moves) do
    %Algorithm{
      step: :OLL,
      initial_state: initial_state,
      moves: moves
    }
  end
  
  def get_oll_algos() do
    [
      make_oll_algo("LLRRBRFL", ["R", "U", "B'", "R", "B", "R2", "U'", "R'", "F", "R", "F'"])
    ]
  end

  def get_oll_algo_map(face = :D) do
    Enum.reduce(
      get_oll_algos(),
      %{},
      fn algo, res_map ->
        Map.put(
          res_map,
          algo.initial_state,
          algo
        )
      end
    )
  end

end
