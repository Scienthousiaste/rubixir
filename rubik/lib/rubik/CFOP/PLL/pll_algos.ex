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

      make_pll_algo(%{UF: "ub", UB: "uf", UR: "ul", UL: "ur"},
        ["L2", "R2", "D", "L2", "R2", "U2", "L2", "R2", "D", "L2", "R2"]),
      make_pll_algo(%{UL: "ur", UR: "ul", URB: "ufr", URF: "ubr"},
        ["R", "U", "R'", "U'", "R'", "F", "R2", "U'", "R'", "U'", "R", "U", "R'", "F'"]),
      make_pll_algo(%{ULB: "ubr", URB: "ubl", UL: "ub", UB: "ul"},
        ["R'", "U", "L'", "U2", "R", "U'", "R'", "U2", "R", "L", "U'"]),
      make_pll_algo(%{URB: "ufr", URF: "ubr", UR: "uf", UF: "ur"},
        ["R", "U", "R'", "F'", "R", "U", "R'", "U'", "R'", "F", "R2", "U'", "R'", "U'"]),

      make_pll_algo(%{ULB: "ubr", URB: "ubl", UL: "uf", UF: "ul"},
        ["L", "U2", "L'", "U2", "L", "F'", "L'", "U'", "L", "U", "L", "F", "L2", "U"]),
      make_pll_algo(%{ULB: "ubr", URB: "ubl", UF: "ur", UR: "uf"},
	    ["R'", "U2", "R", "U2", "R'", "F", "R", "U", "R'", "U'", "R'", "F'", "R2", "U'"]),
      make_pll_algo(%{ULB: "urf", URF: "ulb", UB: "ur", UR: "ub"},
	    ["R'", "U", "R'", "U'", "B'", "R'", "B2", "U'", "B'", "U", "B'", "R", "B", "R"]),
      make_pll_algo(%{ULB: "ubr", URB: "ulf", ULF: "ubl", UB: "ul", UL: "ur", UR: "ub"},
	    ["R2", "D", "B'", "U", "B'", "U'", "B", "D'", "R2", "F'", "U", "F"]),

      make_pll_algo(%{ULB: "ufl", ULF: "ufr", URF: "ulb", UB: "uf", UF: "ul", UL: "ub"},
        ["R'", "U'", "R", "B2", "D", "L'", "U", "L", "U'", "L", "D'", "B2"]),
      make_pll_algo(%{ULB: "ufl", ULF: "ufr", URF: "ulb", UL: "ur", UR: "uf", UF: "ul"},
	    ["R2", "D'", "F", "U'", "F", "U", "F'", "D", "R2", "B", "U'", "B'"]),
      make_pll_algo(%{ULB: "ubr", URB: "ulf", ULF: "ubl", UB: "ul", UL: "uf", UF: "ub"},
        ["R", "U", "R'", "F2", "D'", "L", "U'", "L'", "U", "L'", "D", "F2"]),
      make_pll_algo(%{UL: "ur", UR: "ul", ULF: "ufr", URF: "ufl"},
        ["R'", "U2", "R'", "U'", "B'", "R'", "B2", "U'", "B'", "U", "B'", "R", "B", "U'",
        "R"]),

      make_pll_algo(%{UB: "ul", UL: "ub", UF: "ur", UR: "uf"},
        ["R2", "L2", "D", "R2", "L2", "U", "R'", "L", "F2", "R2", "L2", "B2", "R'", "L",
        "U2"]),
      make_pll_algo(%{ULB: "urf", URF: "ulb", UB: "ul", UL: "ub"},
        ["F", "R", "U'", "R'", "U'", "R", "U", "R'", "F'", "R", "U", "R'", "U'", "R'",
        "F", "R", "F'"]),
      make_pll_algo(%{ULB: "urf", URF: "ulb", UF: "ub", UB: "uf"},
        ["L", "U'", "R", "U2", "L'", "U", "R'", "L", "U'", "R", "U2", "L'", "U", "R'",
        "U"]),
      make_pll_algo(%{ULB: "urf", URF: "ulb", UR: "ul", UL: "ur"},
        ["R'", "U", "L'", "U2", "R", "U'", "L", "R'", "U", "L'", "U2", "R", "U'", "L",
        "U"]),

      make_pll_algo(%{ULF: "ubl", ULB: "ufl", URF: "ubr", URB: "ufr"},
        ["R", "B'", "R'", "F", "R", "B", "R'", "F2", "L'", "B", "L", "F", "L'", "B'", "L"]),

    ]
  end

  def get_pll_algo_map(face = :D) do
    %{}
  end

end
