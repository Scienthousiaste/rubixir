defmodule Rubik.Cube do

  @regex_qturn ~r/(\s*[FRUBLD][2']?\s*)/
  @regex_qturns ~r/\A(\s*[FRUBLD][2']?\s*)*\z/
  @default_number_moves 30
  
  def moves do
    ["R", "R2", "R'", "B", "B2", "B'", "L", "L2", "L'",
     "F", "F2", "F'", "U", "U2", "U'", "D", "D2", "D'"]
  end

  def new_cube do
    %Rubik.State{}
  end

  def new_cube(sequence) do
    build_cube(sequence, valid_sequence?(sequence))
  end

  def scrambled_cube() do
    scrambled_cube(@default_number_moves)
  end

  def scrambled_cube(number_moves) do
    Enum.reduce(0..(number_moves - 1), new_cube(),
      fn _x, cube -> Rubik.Transforms.qturn(cube, Enum.random(moves())) end
    ) 
  end

  def is_solved?(cube) do
    cube == new_cube() 
  end

  defp valid_sequence?(sequence) do
    sequence
    |> String.match?(@regex_qturns)
  end

  defp build_cube(_sequence, _valid_sequence = false) do
    IO.puts "The provided sequence of moves is invalid"
    nil
  end

  defp build_cube(sequence, _valid_sequence = true) do
    sequence
    |> String.split(@regex_qturn, include_captures: true, trim: true)
    |> Enum.map(fn x -> String.trim(x) end)
    |> Rubik.Transforms.qturns
  end

end
