defmodule RubikPLLTest do
  use ExUnit.Case

  alias Rubik.Cube
  alias Rubik.Solver.Helpers
  
  def pll_top_cubies_from_state(initial_state) do
     
  end


  test "PLL algos finish solving the cube" do
    Enum.each(
      Rubik.PLL.Algorithms.get_pll_algos(),
      fn algo ->
        cube = Map.merge(
          Cube.new_cube(),
          algo.initial_state
        )
        |> Rubik.qturns(algo.moves)
        assert Cube.is_solved?(cube)
      end
    )
  end

end





