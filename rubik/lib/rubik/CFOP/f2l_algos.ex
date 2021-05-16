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
    ]
  end

end
