defmodule Rubik.F2L.Algorithms do
  
  alias Rubik.Algorithm

  defp make_algo(initial_state, final_state, moves) do
    %Algorithm{
      step: :F2L,
      initial_state: initial_state,
      solving: final_state,
      moves: moves
    }
  end
  
  def get_f2l_algos() do
    [
      make_algo(%{URF: "rdf", UB: "fr"}, [:DRF, :RF], ["R", "U", "R'"]),
      make_algo(%{URF: "frd", UL: "rf"}, [:DRF, :RF], ["F'", "U'", "F"]),
      make_algo(%{URF: "rdf", UF: "rf"}, [:DRF, :RF], ["U'", "F'", "U", "F"]),
      make_algo(%{URF: "frd", UR: "fr"}, [:DRF, :RF], ["U", "R", "U'", "R'"]),

      make_algo(%{DRF: "drf", UF: "rf"}, [:DRF, :RF], ["U", "R", "U'", "R'", "U'", "F'", "U", "F"]),
      make_algo(%{DRF: "drf", UR: "fr"}, [:DRF, :RF], ["U'", "F'", "U", "F", "U", "R", "U'", "R'"]),
      make_algo(%{DRF: "fdr", UF: "rf"}, [:DRF, :RF], ["F'", "U", "F", "U'", "F'", "U", "F"]),
      make_algo(%{DRF: "fdr", UR: "fr"}, [:DRF, :RF], ["R", "U", "R'", "U'", "R", "U", "R'"]),
      make_algo(%{DRF: "rfd", UR: "fr"}, [:DRF, :RF], ["R", "U'", "R'", "U", "R", "U'", "R'"]),
      make_algo(%{DRF: "rfd", UF: "rf"}, [:DRF, :RF], ["F'", "U'", "F", "U", "F'", "U'", "F"]),

      make_algo(%{URF: "dfr", RF: "rf"}, [:DRF, :RF], ["R", "U", "R'", "U'", "R", "U", "R'", "U'", "R", "U", "R'"]),
      make_algo(%{URF: "dfr", RF: "fr"}, [:DRF, :RF], ["R", "U'", "R'", "U", "F'", "U", "F"]),
      make_algo(%{URF: "rdf", RF: "rf"}, [:DRF, :RF], ["U", "F'", "U", "F", "U", "F'", "U2", "F"]),
      make_algo(%{URF: "rdf", RF: "fr"}, [:DRF, :RF], ["U", "F'", "U'", "F", "U'", "R", "U", "R'"]),
      make_algo(%{URF: "frd", RF: "rf"}, [:DRF, :RF], ["U'", "R", "U'", "R'", "U'", "R", "U2", "R'"]),
      make_algo(%{URF: "frd", RF: "fr"}, [:DRF, :RF], ["U'", "R", "U", "R'", "U", "F'", "U'", "F"]),

      make_algo(%{URF: "rdf", UR: "rf"}, [:DRF, :RF], ["R", "U'", "R'", "U", "U", "F'", "U'", "F"]),
      make_algo(%{URF: "frd", UF: "fr"}, [:DRF, :RF], ["F'", "U", "F", "U'", "U'", "R", "U", "R'"]),
      make_algo(%{URF: "rdf", UB: "rf"}, [:DRF, :RF], ["U", "F'", "U2", "F", "U", "F'", "U2", "F"]),
      make_algo(%{URF: "frd", UL: "fr"}, [:DRF, :RF], ["U'", "R", "U2", "R'", "U'", "R", "U2", "R'"]),
      make_algo(%{URF: "rdf", UL: "rf"}, [:DRF, :RF], ["U", "F'", "U'", "F", "U", "F'", "U2", "F"]),
      make_algo(%{URF: "frd", UB: "fr"}, [:DRF, :RF], ["U'", "R", "U", "R'", "U'", "R", "U2", "R'"]),
      make_algo(%{URF: "rdf", UR: "fr"}, [:DRF, :RF], ["U'", "R", "U'", "R'", "U", "R", "U", "R'"]),
      make_algo(%{URF: "frd", UF: "rf"}, [:DRF, :RF], ["U", "F'", "U", "F", "U'", "F'", "U'", "F"]),
      make_algo(%{URF: "rdf", UL: "fr"}, [:DRF, :RF], ["U'", "R", "U", "R'", "U", "R", "U", "R'"]),
      make_algo(%{URF: "frd", UB: "rf"}, [:DRF, :RF], ["U", "F'", "U'", "F", "U'", "F'", "U'", "F"]),
      make_algo(%{URF: "rdf", UF: "fr"}, [:DRF, :RF], ["U", "F'", "U2", "F", "U'", "R", "U", "R'"]),
      make_algo(%{URF: "frd", UR: "rf"}, [:DRF, :RF], ["U'", "R", "U2", "R'", "U", "F'", "U'", "F"]),

      make_algo(%{URF: "dfr", UF: "fr"}, [:DRF, :RF], ["R", "U", "R'", "U'", "U'", "R", "U", "R'", "U'", "R", "U", "R'"]),
      make_algo(%{URF: "dfr", UR: "rf"}, [:DRF, :RF], ["F'", "U'", "F", "U", "U", "F'", "U'", "F", "U", "F'", "U'", "F"]),
      make_algo(%{URF: "dfr", UL: "fr"}, [:DRF, :RF], ["U2", "R", "U", "R'", "U", "R", "U'", "R'"]),
      make_algo(%{URF: "dfr", UB: "rf"}, [:DRF, :RF], ["U2", "F'", "U'", "F", "U'", "F'", "U", "F"]),
      make_algo(%{URF: "dfr", UB: "fr"}, [:DRF, :RF], ["U", "R", "U2", "R'", "U", "R", "U'", "R'"]),
      make_algo(%{URF: "dfr", UL: "rf"}, [:DRF, :RF], ["U'", "F'", "U2", "F", "U'", "F'", "U", "F"]),
      make_algo(%{URF: "dfr", UR: "fr"}, [:DRF, :RF], ["R", "U2", "R'", "U'", "R", "U", "R'"]),
      make_algo(%{URF: "dfr", UF: "rf"}, [:DRF, :RF], ["F'", "U2", "F", "U", "F'", "U'", "F"]),

      make_algo(%{DRF: "drf", RF: "fr"}, [:DRF, :RF], ["R", "U'", "R'", "U", "F'", "U2", "F", "U", "F'", "U2", "F"]),
      make_algo(%{DRF: "fdr", RF: "rf"}, [:DRF, :RF], ["R", "U'", "R'", "U", "R", "U2", "R'", "U", "R", "U'", "R'"]),
      make_algo(%{DRF: "rfd", RF: "rf"}, [:DRF, :RF], ["R", "U'", "R'", "U'", "R", "U", "R'", "U'", "R", "U2", "R'"]),
      make_algo(%{DRF: "fdr", RF: "fr"}, [:DRF, :RF], ["R", "U", "R'", "U'", "R", "U'", "R'", "U2", "F'", "U'", "F"]),
      make_algo(%{DRF: "rfd", RF: "fr"}, [:DRF, :RF], ["R", "U'", "R'", "U", "F'", "U'", "F", "U'", "F'", "U'", "F"]),
    ]
  end


end
