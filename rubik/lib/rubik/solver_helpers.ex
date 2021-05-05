defmodule Rubik.Solver.Helpers do

  def cubicle_to_expected_cubie(cubicle) do
    String.downcase(Atom.to_string(cubicle))
  end

  def is_cubie_permutation?(goal, actual) do
    MapSet.equal?(
      MapSet.new(String.to_charlist(cubicle_to_expected_cubie(goal))),
      MapSet.new(String.to_charlist(actual))
    )
  end

  def find_where_target_is(cube, target) do
    { target_cubicle, _ } = Enum.find(Map.from_struct(cube),
      fn {cubicle, content} ->
         is_cubie_permutation?(target, content)
      end
    )
    target_cubicle
  end
end
