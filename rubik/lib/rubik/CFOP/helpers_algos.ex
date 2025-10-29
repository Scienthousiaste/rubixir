defmodule Rubik.Solver.AlgoHelpers do
  @rotate_map %{
    id: %{
      ~c"R" => ~c"R",
      ~c"F" => ~c"F",
      ~c"L" => ~c"L",
      ~c"B" => ~c"B",
      ~c"r" => ~c"r",
      ~c"f" => ~c"f",
      ~c"l" => ~c"l",
      ~c"b" => ~c"b"
    },
    qturn: %{
      ~c"R" => ~c"F",
      ~c"F" => ~c"L",
      ~c"L" => ~c"B",
      ~c"B" => ~c"R",
      ~c"r" => ~c"f",
      ~c"f" => ~c"l",
      ~c"l" => ~c"b",
      ~c"b" => ~c"r"
    },
    hturn: %{
      ~c"R" => ~c"L",
      ~c"F" => ~c"B",
      ~c"L" => ~c"R",
      ~c"B" => ~c"F",
      ~c"r" => ~c"l",
      ~c"f" => ~c"b",
      ~c"l" => ~c"r",
      ~c"b" => ~c"f"
    },
    qrturn: %{
      ~c"R" => ~c"B",
      ~c"F" => ~c"R",
      ~c"L" => ~c"F",
      ~c"B" => ~c"L",
      ~c"r" => ~c"b",
      ~c"f" => ~c"r",
      ~c"l" => ~c"f",
      ~c"b" => ~c"l"
    }
  }

  def get_rotations(), do: [:id, :qturn, :hturn, :qrturn]

  def get_rotate_map(:DRF), do: @rotate_map.id
  def get_rotate_map(:DLF), do: @rotate_map.qturn
  def get_rotate_map(:DLB), do: @rotate_map.hturn
  def get_rotate_map(:DRB), do: @rotate_map.qrturn
  def get_rotate_map(:RF), do: @rotate_map.id
  def get_rotate_map(:LF), do: @rotate_map.qturn
  def get_rotate_map(:LB), do: @rotate_map.hturn
  def get_rotate_map(:RB), do: @rotate_map.qrturn

  def get_rotate_map(:DL), do: @rotate_map.id
  def get_rotate_map(:DF), do: @rotate_map.qturn
  def get_rotate_map(:DR), do: @rotate_map.hturn
  def get_rotate_map(:DB), do: @rotate_map.qrturn

  def get_rotate_map(:qturn), do: @rotate_map.qturn
  def get_rotate_map(:qrturn), do: @rotate_map.qrturn
  def get_rotate_map(:hturn), do: @rotate_map.hturn
  def get_rotate_map(:id), do: @rotate_map.id
  def get_rotate_map(nil), do: @rotate_map.id

  def rotate_char(nil, char), do: char
  def rotate_char(new_char, _), do: new_char

  def get_ordering_facelet(~c"U"), do: 0
  def get_ordering_facelet(~c"D"), do: 0
  def get_ordering_facelet(~c"R"), do: 1
  def get_ordering_facelet(~c"L"), do: 1
  def get_ordering_facelet(~c"F"), do: 2
  def get_ordering_facelet(~c"B"), do: 2

  def get_order(cubicle) do
    Enum.map(cubicle, fn char -> get_ordering_facelet(char) end)
  end

  def rotate_corner_or_edge(cubicle, rotation, 2) do
    Rubik.Cube.rotate_edge(cubicle, rotation)
  end

  def rotate_corner_or_edge(cubicle, rotation, 3) do
    Rubik.Cube.rotate_corner(cubicle, rotation)
  end

  def reorder_cubicle(to_reorder) do
    rotation = get_order(to_reorder)
    cubicle_string = List.to_string(to_reorder)

    {
      rotate_corner_or_edge(
        cubicle_string,
        rotation,
        String.length(cubicle_string)
      ),
      rotation
    }
  end

  def rotate_cubicle(to_rotate, rotate_map) do
    {rotated_char_list, new_order} =
      String.to_charlist(to_rotate)
      |> Enum.map(fn char ->
        rotate_char(Map.get(rotate_map, [char]), [char])
      end)
      |> reorder_cubicle

    {String.to_atom(rotated_char_list), new_order, rotate_map}
  end

  def rotate_f2l_cubicle(to_rotate, corner) do
    Atom.to_string(to_rotate)
    |> rotate_cubicle(get_rotate_map(corner))
  end

  def rotate_cubie(to_rotate, rotation, rotate_map) do
    String.to_charlist(to_rotate)
    |> Enum.map(fn char ->
      rotate_char(Map.get(rotate_map, [char]), [char])
    end)
    |> List.to_string()
    |> rotate_corner_or_edge(
      rotation,
      String.length(to_rotate)
    )
  end

  def rotate_initial_state_f2l(initial_state, [corner, _], _face) do
    Enum.reduce(initial_state, %{}, fn {cubicle, cubie}, result_map ->
      {new_cubicle, rotation, rotate_map} =
        rotate_f2l_cubicle(cubicle, corner)

      Map.put(
        result_map,
        new_cubicle,
        rotate_cubie(cubie, rotation, rotate_map)
      )
    end)
  end

  def rotate_moves(moves, rotate_map) do
    Enum.map(
      moves,
      fn move_str ->
        String.to_charlist(move_str)
        |> Enum.map(fn char ->
          rotate_char(Map.get(rotate_map, [char]), [char])
        end)
        |> List.to_string()
      end
    )
  end
end
