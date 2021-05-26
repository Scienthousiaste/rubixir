defmodule Rubik.Solver.Cross.StartingPoint do

  alias Rubik.Solver.AlgoHelpers  

  defp select_biggest_score(rotation, score,
    {_rotation_current, score_current})
    when score > score_current do
    {rotation, score}
  end
  defp select_biggest_score(_rotation, score,
    {rotation_current, score_current})
    when score <= score_current do
    {rotation_current, score_current}
  end

  defp score_from_correct_position(_correct = true),  do: 5.0
  defp score_from_correct_position(_correct = false), do: 0.0

  defp bonus_if_no_rotation(_no_rotation = true),     do: 1.1
  defp bonus_if_no_rotation(_no_rotation = false),    do: 1.0

  defp correct_position?(edge, cube) do
    Rubik.Solver.is_cubie_in_place?(Map.get(cube, edge), edge)
  end

  defp score_edge_for_cross(rotation, edge, cube) do
    score_from_correct_position(
      correct_position?(edge, cube)
    ) * bonus_if_no_rotation(rotation == :id)
  end
  
  def rotation_to_move(:id, :D), do: []
  def rotation_to_move(:qturn, :D), do: ["D"]
  def rotation_to_move(:qrturn, :D), do: ["D'"]
  def rotation_to_move(:hturn, :D), do: ["D2"]

  def compute_score(rotation, cube, face) do
    rotated_cube = Rubik.Transforms.qturns(cube, rotation_to_move(rotation, face))
    Enum.reduce(
      Rubik.Cube.edges(face),
      0,
      fn edge, score ->
        score + score_edge_for_cross(rotation, edge, rotated_cube)
      end
    )
  end

  defp rotation_to_starting_point(rotation) do
    Map.get(%{
      qrturn: :DF,
      qturn:  :DB,
      hturn:  :DR,
      id:     :DL
    },
    rotation)
  end

  def select_starting_point(cube, face) do
    # The starting_point is the cubicle where DL must be found when the cross is done
    {rotation_with_biggest_score, _score} = Enum.reduce(
      AlgoHelpers.get_rotations(),
      {:DL, 0},
      fn rotation, {current_starting_point, score}  -> 
        select_biggest_score(
          rotation,
          compute_score(rotation, cube, face),
          {current_starting_point, score}
        )
      end
    )
    rotation_to_starting_point(rotation_with_biggest_score)
  end

end
