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
      make_oll_algo("LLRRBRFL", ["R", "U", "B'", "R", "B", "R2", "U'", "R'", "F", "R", "F'"]),

      make_oll_algo("FLRFBRFL", ["R'", "F", "R", "F'", "U2", "R'", "F", "R", "F2", "U2", "F"]),
      make_oll_algo("LBRUBRFL", ["F'", "B2", "L", "B'", "L", "F", "U2", "F'", "L", "B'", "F"]),

      make_oll_algo("FLURBRFL", ["R'", "U2", "R'", "F", "R", "F'", "U'", "F'", "U'", "F", "U'", "R"]),
      make_oll_algo("LUBUBRFL", ["R", "U", "R'", "U", "R'", "F", "R", "F'", "U2", "R'", "F", "R", "F'"]),
      make_oll_algo("UUUUBRFL", ["L", "R'", "F2", "L'", "R", "U2", "L", "R'", "F", "L'", "R", "U2", "L", "R'", "F2", "L'", "R"]),

      make_oll_algo("LUURBRFL", ["R'", "U2", "F", "R", "U", "R'", "U'", "F2", "U2", "F", "R"]),
      make_oll_algo("UBBUBRFL", ["F", "R", "U", "R'", "U", "F'", "U2", "F'", "L", "F", "L'"]),
      make_oll_algo("FBRRURUL", ["R'", "U'", "F'", "U", "F'", "L", "F", "L'", "F", "R"]),
      make_oll_algo("LLRRURUL", ["R", "U'", "B2", "D", "B'", "U2", "B", "D'", "B2", "U", "R'"]),
      make_oll_algo("FBRRBUFU", ["F", "U", "R", "U'", "R'", "U", "R", "U'", "R'", "F'"]),
      make_oll_algo("LLRRBUFU", ["L'", "B'", "L", "U'", "R'", "U", "R", "U'", "R'", "U", "R", "L'", "B", "L"]),


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
