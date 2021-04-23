defmodule Rubik.Transforms do
  
  defp corner_to_corner([h | t] = corner_list, _direction = :next) do
    Enum.zip(t ++ [h], corner_list)
  end

  defp corner_to_corner(corner_list, _direction = :previous) do
    Enum.zip([List.last(corner_list)] ++ corner_list, corner_list)
  end

  defp rotate_corner(corner, [first, second, third]) do
    String.at(corner, first)
      <> String.at(corner, second)
      <> String.at(corner, third)
  end

  defp corner_transformation(cube, rotation, corner_tuples) do
    Enum.reduce(corner_tuples, cube,
      fn ({from, to}, acc_cube) -> 
        Map.update!(acc_cube, to,
          fn _val -> rotate_corner(Map.get(cube, from), rotation) end) 
      end
    )
  end

  defp edge_to_edge([h | t] = edges) do
    Enum.zip(edges, t ++ [h]) 
  end

  defp may_switch_edge(edge, :switch) do
    String.at(edge, 1) <> String.at(edge, 0) 
  end
  defp may_switch_edge(edge, :no_switch) do
    edge
  end

  defp edge_transformation(cube, edges, switch) do
    edge_to_edge(edges)
    |> Enum.reduce(cube, 
      fn ({from, to}, acc_cube) ->
        Map.update!(acc_cube, to,
          fn _val -> may_switch_edge(Map.get(cube, from), switch) end)
      end
    )
  end

  def apply(cube, "F") do
    cube
    |> corner_transformation(
      [1, 0, 2],
      corner_to_corner([:ULF, :URF, :DRF, :DLF], :previous)
    )
    |> edge_transformation([:UF, :RF, :DF, :LF], :no_switch)
  end

  def apply(cube, "B") do
    cube
    |> corner_transformation(
      [1, 0, 2],
      corner_to_corner([:ULB, :URB, :DRB, :DLB], :next)
    )
    |> edge_transformation([:UB, :LB, :DB, :RB], :no_switch)
  end

  def apply(cube, "U") do
    cube
    |> corner_transformation(
      [0, 2, 1],
      corner_to_corner([:ULB, :URB, :URF, :ULF], :previous)
    )
    |> edge_transformation([:UB, :UR, :UF, :UL], :no_switch)
  end

  def apply(cube, "D") do
    cube
    |> corner_transformation(
      [0, 2, 1],
      corner_to_corner([:DLB, :DRB, :DRF, :DLF], :next)
    )
    |> edge_transformation([:DF, :DR, :DB, :DL], :no_switch)
  end

  def apply(cube, "L") do
    cube
    |> corner_transformation(
      [2, 1, 0],
      corner_to_corner([:ULB, :DLB, :DLF, :ULF], :next)
    )
    |> edge_transformation([:UL, :LF, :DL, :LB], :switch)
  end

  def apply(cube, "R") do
    cube
    |> corner_transformation(
      [2, 1, 0],
      corner_to_corner([:URF, :URB, :DRB, :DRF], :previous)
    )
    |> edge_transformation([:UR, :RB, :DR, :RF], :switch)
  end

end
