defmodule Channel.Helpers do
  
  def get_pattern("superflip") do
    [ "U", "R2", "F", "B", "R", "B2", "R", "U2", "L", "B2",
      "R", "U'", "D'", "R2", "F", "R'", "L", "B2", "U2", "F2"
    ]
  end

  def get_pattern("cube_in_cube_in_cube") do
    [ "U'", "L'", "U'", "F'", "R2", "B'", "R", "F", "U", "B2",
      "U", "B'", "L", "U'", "F", "U", "R", "F'"]
  end

end
