defmodule Rubik.Transforms do
  
  def apply(cube, "R") do
    #urf, bru, drb, frd 
    %Rubik.State{ cube |
      URB: rotate_corner(cube."URF"),
      DRB: rotate_corner(cube."URB"),
      DRF: rotate_corner(cube."DRB"),
      URF: rotate_corner(cube."DRF")
    }
  end 

  defp rotate_corner(corner) do
    str = Atom.to_string(corner)
    String.to_atom(String.at(str, 2) <> String.at(str, 1) <> String.at(str, 0))
  end
end
