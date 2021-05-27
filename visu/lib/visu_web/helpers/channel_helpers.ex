defmodule Channel.Helpers do
  
  def get_patterns() do
    [
      %{ name: "superflip_pattern", formatted: "Superflip" },
      %{ name: "cube_in_cube_in_cube_pattern", formatted: "Cube in Cube in Cube" },
      %{ name: "anaconda_pattern", formatted: "Anaconda" },
      %{ name: "spiral_pattern", formatted: "Spiral" },
      %{ name: "checkerboard_pattern", formatted: "Checkerboard" },
      %{ name: "six_spots_pattern", formatted: "Six Spots" },
      %{ name: "tetris_pattern", formatted: "Tetris" },
      %{ name: "exchanged_peaks_pattern", formatted: "Exchanged Peaks" },
    ]
  end

  def get_pattern("superflip_pattern") do
    [ "U", "R2", "F", "B", "R", "B2", "R", "U2", "L", "B2",
      "R", "U'", "D'", "R2", "F", "R'", "L", "B2", "U2", "F2"
    ]
  end

  def get_pattern("cube_in_cube_in_cube_pattern") do
    [ "U'", "L'", "U'", "F'", "R2", "B'", "R", "F", "U", "B2",
      "U", "B'", "L", "U'", "F", "U", "R", "F'"]
  end

  def get_pattern("anaconda_pattern") do
    ["L", "U", "B'", "U'", "R", "L'", "B", "R'", "F", "B'",
      "D", "R", "D'", "F'"]
  end

  def get_pattern("spiral_pattern") do
    ["L'", "B'", "D", "U", "R", "U'", "R'", "D2", "R2", "D",
      "L", "D'", "L'", "R'", "F", "U"]
  end

  def get_pattern("checkerboard_pattern") do
    ["B", "D", "F'", "B'", "D", "L2", "U", "L", "U'", "B",
      "D'", "R", "B", "R", "D'", "R", "L'", "F", "U2", "D"]
  end

  def get_pattern("six_spots_pattern") do
    ["U", "D'", "R", "L'", "F", "B'", "U", "D'"]
  end

  def get_pattern("tetris_pattern") do
    ["L", "R", "F", "B", "U'", "D'", "L'", "R'"]
  end

  def get_pattern("exchanged_peaks_pattern") do
    ["F", "U2", "L", "F", "L'", "B", "L", "U", "B'", "R'",
      "L'", "U", "R'", "D'", "F'", "B", "R2"]
  end

end
