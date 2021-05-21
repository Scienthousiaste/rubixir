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

      make_oll_algo("FBRRUUUU", ["L", "U'", "R'", "U", "L'", "U", "R", "U", "R'", "U", "R"]),
      make_oll_algo("LLRRUUUU", ["R", "U", "R'", "U", "R", "U'", "R'", "U", "R", "U2", "R'"]),
      make_oll_algo("FLBUUUUU", ["L'", "U", "R", "U'", "L", "U", "R'"]),
      make_oll_algo("LBRUUUUU", ["R'", "U2", "R", "U", "R'", "U", "R"]),
      make_oll_algo("UUBFUUUU", ["R'", "F'", "L", "F", "R", "F'", "L'", "F"]),
      make_oll_algo("FUUFUUUU", ["R2", "D", "R'", "U2", "R", "D'", "R'", "U2", "R'"]),
      make_oll_algo("LUBUUUUU", ["R'", "F'", "L'", "F", "R", "F'", "L", "F"]),
      make_oll_algo("UUUUBRUU", ["L", "R'", "F'", "L'", "R", "U2", "L", "R'", "F'", "L'", "R"]),
      make_oll_algo("UUUUBUFU", ["L'", "R", "U", "R'", "U'", "L", "R'", "F", "R", "F'"]),


      make_oll_algo("UBRFURFU", ["L", "F", "R'", "F", "R", "F2", "L'"]),
      make_oll_algo("FURUURFU", ["F", "R'", "F'", "R", "U", "R", "U'", "R'"]),
      make_oll_algo("FLBUURFU", ["R'", "U'", "R", "F", "R'", "F'", "U", "F", "R", "F'"]),
      make_oll_algo("UBBUURFU", ["U'", "R", "U2", "R'", "U'", "R", "U'", "R2", "F'", "U'", "F", "U", "R"]),
      make_oll_algo("LLBFURFU", ["F", "R", "U", "R'", "U'", "R", "U", "R'", "U'", "F'"]),
      make_oll_algo("FBBFURFU", ["L", "F'", "L'", "F", "U2", "L2", "B", "L", "B'", "L"]),

      make_oll_algo("UBBUUUFL", ["U'", "R'", "U2", "R", "U", "R'", "U", "R2", "B", "U", "B'", "U'", "R'"]),
      make_oll_algo("FLURUUFL", ["L", "F2", "R'", "F'", "R", "F'", "L'"]),
      make_oll_algo("UBURUUFL", ["R'", "U2", "R2", "B'", "R'", "B", "R'", "U2", "R"]),
      make_oll_algo("FBRRUUFL", ["F'", "L'", "U'", "L", "U", "L'", "U'", "L", "U", "F"]),
      make_oll_algo("LLBFUUFL", ["R'", "F", "R'", "F'", "R2", "U2", "B'", "R", "B", "R'"]),
      make_oll_algo("FBBFUUFL", ["R'", "F", "R", "F'", "U2", "R2", "B'", "R'", "B", "R'"]),

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
