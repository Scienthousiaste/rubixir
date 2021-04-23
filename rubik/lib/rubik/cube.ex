defmodule Rubik.Cube do

  @regex_qturn ~r/(\s*[FRUBLD][2']?\s*)/
  @regex_qturns ~r/\A(\s*[FRUBLD][2']?\s*)*\z/
  
  def new_cube do
    %Rubik.State{}
  end

  def new_cube(sequence) do
    build_cube(sequence, valid_sequence?(sequence))
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
