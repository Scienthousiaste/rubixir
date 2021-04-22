defmodule Rubik.Cube do
  
  def new_cube do
    %Rubik.State{}
  end

  def new_cube(sequence) do
    build_cube(sequence, valid_sequence?(sequence))
  end

  def valid_sequence?(sequence) do
    sequence
    |> String.match?(~r/\A(\s*[FRUBLD][2']?\s*)*\z/)
  end

  def build_cube(_sequence, _valid_sequence = false) do
    IO.puts "The provided sequence of moves is invalid"
    nil
  end

  def build_cube(sequence, _valid_sequence = true) do
    sequence
  end

end
