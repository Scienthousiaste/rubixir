defmodule Rubik.Cube do

  @regex_qturn ~r/(\s*[FRUBLD][2']?\s*)/
  @regex_qturns ~r/\A(\s*[FRUBLD][2']?\s*)*\z/
  @default_number_moves 30
  
  def moves do
    ["R", "R2", "R'", "B", "B2", "B'", "L", "L2", "L'",
     "F", "F2", "F'", "U", "U2", "U'", "D", "D2", "D'"]
  end

  def faces(), do: [:D, :F, :L, :B, :R, :U]

  def edges(:F), do: [:UF, :RF, :DF, :LF] 
  def edges(:L), do: [:UL, :LF, :DL, :LB]
  def edges(:B), do: [:UB, :LB, :DB, :RB]
  def edges(:R), do: [:UR, :RB, :DR, :RF]
  def edges(:U), do: [:UB, :UR, :UF, :UL]
  def edges(:D), do: [:DF, :DR, :DB, :DL]

  def corners(:F), do: [:ULF, :URF, :DRF, :DLF]
  def corners(:L), do: [:ULB, :ULF, :DLF, :DLB]
  def corners(:B), do: [:ULB, :URB, :DRB, :DLB]
  def corners(:R), do: [:URB, :URF, :DRF, :DRB]
  def corners(:U), do: [:ULF, :ULB, :URB, :URF]
  def corners(:D), do: [:DLF, :DLB, :DRB, :DRF]

  def edges_and_corners(face) do
    %{
      edges: edges(face),
      corners: corners(face)
    }
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

  def test_cubie(nil, 2) do
    "xx"
  end
  def test_cubie(nil, 3) do
    "xxx"
  end 
  def test_cubie(state_value, _) do
    state_value
  end

  def cube_test(state) do
    c_t = Enum.reduce(Map.from_struct(%Rubik.State{}), %{},
      fn {cubicle, cubie}, map_test -> Map.put(
        map_test,
        cubicle,
        test_cubie(Map.get(state, cubicle), String.length(cubie)))
      end 
    )
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

  def rotate_corner(corner, [first, second, third]) do
    String.at(corner, first)
      <> String.at(corner, second)
      <> String.at(corner, third)
  end

  def rotate_edge(edge, [first, second]) when first > second do
    String.at(edge, 1) <> String.at(edge, 0)
  end
  def rotate_edge(edge, [first, second]) when first < second do
    String.at(edge, 0) <> String.at(edge, 1)
  end

end


