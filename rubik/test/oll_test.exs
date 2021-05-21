defmodule RubikOLLTest do
  use ExUnit.Case

  alias Rubik.Cube
  alias Rubik.Solver.Helpers

  defp u_or_x(true), do: 'u'
  defp u_or_x(false), do: 'x'
  defp make_dummy_oll_cubie([oll_state_char], cubicle) do
    Enum.map(
      Atom.to_charlist(cubicle),
      fn char -> u_or_x(char == oll_state_char) end
    )
    |> List.to_string
  end 

  defp oll_cubies_from_state(oll_state) do
    top_cubicles = [:ULF, :ULB, :URB, :URF, :UB, :UR, :UF, :UL]
    
    {result, _} = Enum.reduce(
      top_cubicles,
      { %{}, 0 },
      fn cubicle, {map_result, idx} ->
        {
          Map.put(
            map_result,
            cubicle,
            make_dummy_oll_cubie(
              String.to_charlist(String.at(oll_state, idx)),
              cubicle
            )
          ),
          idx + 1
        }
      end
    )
    result
  end

  test "OLL algos orient last layer and don't touch F2L" do
    f2l_state = %{
      DF: "df",
      DR: "dr",
      DL: "dl",
      DB: "db",
      DRF: "drf", 
      DRB: "drb",
      DLF: "dlf",
      DLB: "dlb",
      LF: "lf",
      LB: "lb",
      RB: "rb",
      RF: "rf"
    }

    oll_goal = [:DF, :DR, :DL, :DB, :DRF, :DRB, :DLF, :DLB, :LF,
      :LB, :RB, :RF]

    Enum.each(
      Rubik.OLL.Algorithms.get_oll_algos(),
      fn algo ->
        cube = Cube.cube_test(
          Map.merge(
            f2l_state,
            oll_cubies_from_state(algo.initial_state)
          )
        )
        |> Rubik.qturns(algo.moves)

        assert (
          Helpers.goal_reached?(cube, oll_goal)
          and Rubik.Solver.OLL.oll_completed?(cube, :D)
        )
      end
    )
  end

end
