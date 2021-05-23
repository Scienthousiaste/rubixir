defmodule RubikShortSolutionsTest do
  use ExUnit.Case


  defp short_sequences_to_solve_fast() do
    [{"LU", 2}, {"DF", 2}]
  end

  test "Some short move sequences that should be dealt with very fast" do
    
    Enum.each(
      short_sequences_to_solve_fast(),
      fn {seq, n} ->
        %{moves: moves} = Rubik.new_cube(seq)
        |> Rubik.solve_cube
        assert Enum.count(moves) == n
      end
    )
  end

end
