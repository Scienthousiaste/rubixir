defmodule Rubik.PLL.Algorithms do
  
  alias Rubik.Algorithm
  alias Rubik.Solver.AlgoHelpers

  def make_pll_algo(initial_state, moves) do
    %Algorithm{
      step: :PLL,
      initial_state: initial_state,
      moves: moves
    }
  end
  
  def get_pll_algos() do
    [
      make_pll_algo(%{ULB: "ubr", URB: "ufr", URF: "ulb"},
        ["R'", "F", "R'", "B2", "R", "F'", "R'", "B2", "R2"]),
      make_pll_algo(%{URB: "ulf", ULF: "ufr", URF: "ubr"},
        ["R", "B'", "R", "F2", "R'", "B", "R", "F2", "R2"]),
      make_pll_algo(%{UL: "ur", UR: "uf", UF: "ul"},
        ["R2", "U", "R", "U", "R'", "U'", "R'", "U'", "R'", "U", "R'"]),
      make_pll_algo(%{UL: "uf", UF: "ur", UR: "ul"},
        ["R", "U'", "R", "U", "R", "U", "R", "U'", "R'", "U'", "R2"]),

      
    ]
  end

  def get_pll_algo_map(face = :D) do
    %{}
  end

end
