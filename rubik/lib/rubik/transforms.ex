defmodule Rubik.Transforms do
  
  defp corner_to_corner([h | t] = corner_list, _direction = :next) do
    Enum.zip(corner_list, t ++ [h])
  end

  defp corner_to_corner(corner_list, _direction = :previous) do
    Enum.zip(corner_list, [List.last(corner_list)] ++ corner_list)
  end

  defp corner_transformation(cube, rotation, corner_tuples) do
    Enum.reduce(corner_tuples, cube,
      fn ({from, to}, acc_cube) -> 
        Map.update!(acc_cube, from,
          fn _val -> rotate_corner(Map.get(cube, to), rotation) end) 
      end
    )
  end

  defp rotate_corner(corner, [first, second, third]) do
    String.at(corner, first)
      <> String.at(corner, second)
      <> String.at(corner, third)
  end

  def apply(cube, "F") do
    corner_transformation(
      cube,
      [1, 0, 2],
      corner_to_corner([:ULF, :URF, :DRF, :DLF], :previous)
    )
  end

  def apply(cube, "B") do
    corner_transformation(
      cube,
      [1, 0, 2],
      corner_to_corner([:ULB, :URB, :DRB, :DLB], :next)
    )
  end

  def apply(cube, "U") do
    corner_transformation(
      cube,
      [0, 2, 1],
      corner_to_corner([:ULB, :URB, :URF, :ULF], :previous)
    )
  end

  def apply(cube, "D") do
    corner_transformation(
      cube,
      [0, 2, 1],
      corner_to_corner([:DLB, :DRB, :DRF, :DLF], :next)
    )
  end

  def apply(cube, "L") do
    corner_transformation(
      cube,
      [2, 1, 0],
      corner_to_corner([:ULB, :DLB, :DLF, :ULF], :next)
    )
  end

  def apply(cube, "R") do
    corner_transformation(
      cube,
      [2, 1, 0],
      corner_to_corner([:URF, :URB, :DRB, :DRF], :previous)
    )
  end

end
