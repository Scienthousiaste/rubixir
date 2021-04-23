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

  defp corner_transformation(cube, { rotation, {corner_list, direction} } ) do
    corner_tuples = corner_to_corner(corner_list, direction)
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

  defp edge_transformation(cube, {edges, switch}) do
    edge_to_edge(edges)
    |> Enum.reduce(cube, 
      fn ({from, to}, acc_cube) ->
        Map.update!(acc_cube, to,
          fn _val -> may_switch_edge(Map.get(cube, from), switch) end)
      end
    )
  end

  defp get_corner_data("F") do
    { [1, 0, 2], { [:ULF, :URF, :DRF, :DLF], :previous } }
  end
  defp get_corner_data("B") do
    { [1, 0, 2], { [:ULB, :URB, :DRB, :DLB], :next } }
  end
  defp get_corner_data("U") do
    { [0, 2, 1], { [:ULB, :URB, :URF, :ULF], :previous } }
  end
  defp get_corner_data("D") do
    { [0, 2, 1], { [:DLB, :DRB, :DRF, :DLF], :next } }
  end
  defp get_corner_data("L") do
    { [2, 1, 0], { [:ULB, :DLB, :DLF, :ULF], :next } }
  end
  defp get_corner_data("R") do
    { [2, 1, 0], { [:URF, :URB, :DRB, :DRF], :previous } }
  end

  defp switch_direction(:next) do
    :previous
  end
  defp switch_direction(:previous) do
    :next
  end

  defp make_switch_direction({ rotation, { corner_list, direction }}) do
    { rotation, { corner_list, switch_direction(direction) }}
  end

  defp get_reverse_corner_data(base) do
    get_corner_data(base)
    |> make_switch_direction() 
  end
  
  defp get_edge_data("F"), do: { [:UF, :RF, :DF, :LF], :no_switch }
  defp get_edge_data("B"), do: { [:UB, :LB, :DB, :RB], :no_switch }
  defp get_edge_data("U"), do: { [:UB, :UR, :UF, :UL], :no_switch }
  defp get_edge_data("D"), do: { [:DF, :DR, :DB, :DL], :no_switch }
  defp get_edge_data("L"), do: { [:UL, :LF, :DL, :LB], :switch }
  defp get_edge_data("R"), do: { [:UR, :RB, :DR, :RF], :switch }

  defp make_reverse_edge_list({ edge_list, switch }) do
    { Enum.reverse(edge_list), switch }
  end

  defp get_reverse_edge_data(base) do
    get_edge_data(base)
    |> make_reverse_edge_list 
  end

  def qturn(cube, <<base::bytes-size(1)>> <> "2") do
   cube
    |> qturn(base)
    |> qturn(base)
  end

  def qturn(cube, <<base::bytes-size(1)>> <> "'") do
   cube
   |> corner_transformation(get_reverse_corner_data(base))
   |> edge_transformation(get_reverse_edge_data(base))
  end

  def qturn(cube, transformation) do
    cube
    |> corner_transformation(get_corner_data(transformation))
    |> edge_transformation(get_edge_data(transformation))
  end

end
