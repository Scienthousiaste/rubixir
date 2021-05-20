defmodule Rubik.F2L.Algorithms do
  
  alias Rubik.Algorithm
  alias Rubik.Solver.AlgoHelpers

  def make_f2l_algo(initial_state, moves) do
    %Algorithm{
      step: :F2L,
      initial_state: initial_state,
      solving: [:DRF, :RF],
      moves: moves
    }
  end
  
  def get_f2l_algos() do
    [
      make_f2l_algo(%{URF: "rdf", UB: "fr"},  ["R", "U", "R'"]),
      make_f2l_algo(%{URF: "frd", UL: "rf"},  ["F'", "U'", "F"]),
      make_f2l_algo(%{URF: "rdf", UF: "rf"},  ["U'", "F'", "U", "F"]),
      make_f2l_algo(%{URF: "frd", UR: "fr"},  ["U", "R", "U'", "R'"]),

      make_f2l_algo(%{DRF: "drf", UF: "rf"},  ["U", "R", "U'", "R'", "U'", "F'", "U", "F"]),
      make_f2l_algo(%{DRF: "drf", UR: "fr"},  ["U'", "F'", "U", "F", "U", "R", "U'", "R'"]),
      make_f2l_algo(%{DRF: "fdr", UF: "rf"},  ["F'", "U", "F", "U'", "F'", "U", "F"]),
      make_f2l_algo(%{DRF: "fdr", UR: "fr"},  ["R", "U", "R'", "U'", "R", "U", "R'"]),
      make_f2l_algo(%{DRF: "rfd", UR: "fr"},  ["R", "U'", "R'", "U", "R", "U'", "R'"]),
      make_f2l_algo(%{DRF: "rfd", UF: "rf"},  ["F'", "U'", "F", "U", "F'", "U'", "F"]),

      make_f2l_algo(%{URF: "dfr", RF: "rf"},  ["R", "U", "R'", "U'", "R", "U", "R'", "U'", "R", "U", "R'"]),
      make_f2l_algo(%{URF: "dfr", RF: "fr"},  ["R", "U'", "R'", "U", "F'", "U", "F"]),
      make_f2l_algo(%{URF: "rdf", RF: "rf"},  ["U", "F'", "U", "F", "U", "F'", "U2", "F"]),
      make_f2l_algo(%{URF: "rdf", RF: "fr"},  ["U", "F'", "U'", "F", "U'", "R", "U", "R'"]),
      make_f2l_algo(%{URF: "frd", RF: "rf"},  ["U'", "R", "U'", "R'", "U'", "R", "U2", "R'"]),
      make_f2l_algo(%{URF: "frd", RF: "fr"},  ["U'", "R", "U", "R'", "U", "F'", "U'", "F"]),

      make_f2l_algo(%{URF: "rdf", UR: "rf"},  ["R", "U'", "R'", "U2", "F'", "U'", "F"]),
      make_f2l_algo(%{URF: "frd", UF: "fr"},  ["F'", "U", "F", "U2", "R", "U", "R'"]),
      make_f2l_algo(%{URF: "rdf", UB: "rf"},  ["U", "F'", "U2", "F", "U", "F'", "U2", "F"]),
      make_f2l_algo(%{URF: "frd", UL: "fr"},  ["U'", "R", "U2", "R'", "U'", "R", "U2", "R'"]),
      make_f2l_algo(%{URF: "rdf", UL: "rf"},  ["U", "F'", "U'", "F", "U", "F'", "U2", "F"]),
      make_f2l_algo(%{URF: "frd", UB: "fr"},  ["U'", "R", "U", "R'", "U'", "R", "U2", "R'"]),
      make_f2l_algo(%{URF: "rdf", UR: "fr"},  ["U'", "R", "U'", "R'", "U", "R", "U", "R'"]),
      make_f2l_algo(%{URF: "frd", UF: "rf"},  ["U", "F'", "U", "F", "U'", "F'", "U'", "F"]),
      make_f2l_algo(%{URF: "rdf", UL: "fr"},  ["U'", "R", "U", "R'", "U", "R", "U", "R'"]),
      make_f2l_algo(%{URF: "frd", UB: "rf"},  ["U", "F'", "U'", "F", "U'", "F'", "U'", "F"]),
      make_f2l_algo(%{URF: "rdf", UF: "fr"},  ["U", "F'", "U2", "F", "U'", "R", "U", "R'"]),
      make_f2l_algo(%{URF: "frd", UR: "rf"},  ["U'", "R", "U2", "R'", "U", "F'", "U'", "F"]),

      make_f2l_algo(%{URF: "dfr", UF: "fr"},  ["R", "U", "R'", "U2", "R", "U", "R'", "U'", "R", "U", "R'"]),
      make_f2l_algo(%{URF: "dfr", UR: "rf"},  ["F'", "U'", "F", "U", "U", "F'", "U'", "F", "U", "F'", "U'", "F"]),
      make_f2l_algo(%{URF: "dfr", UL: "fr"},  ["U2", "R", "U", "R'", "U", "R", "U'", "R'"]),
      make_f2l_algo(%{URF: "dfr", UB: "rf"},  ["U2", "F'", "U'", "F", "U'", "F'", "U", "F"]),
      make_f2l_algo(%{URF: "dfr", UB: "fr"},  ["U", "R", "U2", "R'", "U", "R", "U'", "R'"]),
      make_f2l_algo(%{URF: "dfr", UL: "rf"},  ["U'", "F'", "U2", "F", "U'", "F'", "U", "F"]),
      make_f2l_algo(%{URF: "dfr", UR: "fr"},  ["R", "U2", "R'", "U'", "R", "U", "R'"]),
      make_f2l_algo(%{URF: "dfr", UF: "rf"},  ["F'", "U2", "F", "U", "F'", "U'", "F"]),

      make_f2l_algo(%{DRF: "drf", RF: "fr"},  ["R", "U'", "R'", "U", "F'", "U2", "F", "U", "F'", "U2", "F"]),
      make_f2l_algo(%{DRF: "fdr", RF: "rf"},  ["R", "U'", "R'", "U", "R", "U2", "R'", "U", "R", "U'", "R'"]),
      make_f2l_algo(%{DRF: "rfd", RF: "rf"},  ["R", "U'", "R'", "U'", "R", "U", "R'", "U'", "R", "U2", "R'"]),
      make_f2l_algo(%{DRF: "fdr", RF: "fr"},  ["R", "U", "R'", "U'", "R", "U'", "R'", "U2", "F'", "U'", "F"]),
      make_f2l_algo(%{DRF: "rfd", RF: "fr"},  ["R", "U'", "R'", "U", "F'", "U'", "F", "U'", "F'", "U'", "F"]),
    ]
  end

  def get_algo_initial_cubicles() do
    [
      [:URF, :UB],
      [:URF, :UL],
      [:URF, :UF],
      [:URF, :UR],
      [:DRF, :UR],
      [:DRF, :UF],
      [:URF, :RF],
      [:DRF, :RF]
    ]
  end

  def key_from_state(state) do
    Enum.reduce(
      state,
      "",
      fn {key, val}, result ->
       result <> Atom.to_string(key) <> ":" <> val 
      end
    )
  end

  def rotate_f2l_algo(algo, goal, face) do
    %Rubik.Algorithm{
      initial_state: AlgoHelpers.rotate_initial_state(algo.initial_state,
        goal, face),
      moves: AlgoHelpers.rotate_moves(algo.moves, goal),
      solving: goal,
      step: :F2L
    }
  end

  def get_f2l_algo_map(goal, face) do
    Enum.reduce(
      get_f2l_algos(),
      %{},
      fn algo, acc_map -> 
        rotated_algo = rotate_f2l_algo(algo, goal, face)
        Map.put(acc_map,
          key_from_state(rotated_algo.initial_state),
          rotated_algo
        )
      end
    )
  end

end
