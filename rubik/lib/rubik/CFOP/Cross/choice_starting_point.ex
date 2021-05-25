defmodule Rubik.Solver.Cross.StartingPoint do

  alias Rubik.Solver.AlgoHelpers  

  defp select_biggest_score(cubicle, score, {_cubicle_current, score_current})
    when score > score_current do
    {cubicle, score}
  end
  defp select_biggest_score(_cubicle, score, {cubicle_current, score_current})
    when score <= score_current do
    {cubicle_current, score_current}
  end

  defp score_from_correct_position(_correct = true),  do: 5.0
  defp score_from_correct_position(_correct = false), do: 0.0

  defp bonus_if_no_rotation(_no_rotation = true),     do: 1.1
  defp bonus_if_no_rotation(_no_rotation = false),    do: 1.0

  defp correct_cross_position?(edge, rotate_map, cube) do
    { cubicle, _, _ } = AlgoHelpers.rotate_cubicle(
      Atom.to_string(edge),
      rotate_map
    )
    Rubik.Solver.is_cubie_in_place?(
      Map.get(cube, cubicle),
      edge
    )
  end

  defp score_edge_for_cross(edge, rotate_map, cube) do
    score_from_correct_position(
      correct_cross_position?(edge, rotate_map, cube)
    ) * bonus_if_no_rotation(Map.get(rotate_map, 'R') == 'R')
  end

  defp compute_score(base_cubicle, cube, face) do
    rotate_map = AlgoHelpers.get_rotate_map(base_cubicle)
    Enum.reduce(
      Rubik.Cube.edges(face),
      0,
      fn edge, score ->
        score + score_edge_for_cross(edge, rotate_map, cube)
      end
    )
  end

  def select_starting_point(cube, face) do
    cubicles_of_interest = Rubik.Cube.edges(face)

    {starting_point, score} = Enum.reduce(
      cubicles_of_interest,
      {:DL, 0},
      fn cubicle, {current_starting_point, score}  -> 
        select_biggest_score(
          cubicle,
          compute_score(cubicle, cube, face),
          {current_starting_point, score}
        )
      end
    )
    IO.inspect ["starting point here: ", starting_point, score]
    starting_point
  end

end
