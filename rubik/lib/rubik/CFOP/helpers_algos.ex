defmodule Rubik.Solver.AlgoHelpers do
  
  @rotate_map %{
    id: %{ 'R' => 'R', 'F' => 'F', 'L' => 'L', 'B' => 'B',
           'r' => 'r', 'f' => 'f', 'l' => 'l', 'b' => 'b' },
    qturn: %{ 'R' => 'F', 'F' => 'L', 'L' => 'B', 'B' => 'R', 
              'r' => 'f', 'f' => 'l', 'l' => 'b', 'b' => 'r' },
    hturn: %{ 'R' => 'L', 'F' => 'B', 'L' => 'R', 'B' => 'F', 
              'r' => 'l', 'f' => 'b', 'l' => 'r', 'b' => 'f' },
    qrturn: %{ 'R' => 'B', 'F' => 'R', 'L' => 'F', 'B' => 'L', 
               'r' => 'b', 'f' => 'r', 'l' => 'f', 'b' => 'l' },
  }

  def get_rotations(), do: [:id, :qturn, :hturn, :qrturn]

  def get_rotate_map(:DRF),     do: @rotate_map.id 
  def get_rotate_map(:DLF),     do: @rotate_map.qturn 
  def get_rotate_map(:DLB),     do: @rotate_map.hturn
  def get_rotate_map(:DRB),     do: @rotate_map.qrturn
  def get_rotate_map(:RF),      do: @rotate_map.id 
  def get_rotate_map(:LF),      do: @rotate_map.qturn 
  def get_rotate_map(:LB),      do: @rotate_map.hturn
  def get_rotate_map(:RB),      do: @rotate_map.qrturn
  
  def get_rotate_map(:DL),      do: @rotate_map.id
  def get_rotate_map(:DF),      do: @rotate_map.qturn
  def get_rotate_map(:DR),      do: @rotate_map.hturn
  def get_rotate_map(:DB),      do: @rotate_map.qrturn

  def get_rotate_map(:qturn),   do: @rotate_map.qturn  
  def get_rotate_map(:qrturn),  do: @rotate_map.qrturn
  def get_rotate_map(:hturn),   do: @rotate_map.hturn
  def get_rotate_map(:id),      do: @rotate_map.id
  def get_rotate_map(nil),      do: @rotate_map.id


  def rotate_char(nil, char),   do: char
  def rotate_char(new_char, _), do: new_char 

  def get_ordering_facelet('U'), do: 0
  def get_ordering_facelet('D'), do: 0
  def get_ordering_facelet('R'), do: 1
  def get_ordering_facelet('L'), do: 1
  def get_ordering_facelet('F'), do: 2
  def get_ordering_facelet('B'), do: 2

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
    { rotated_char_list, new_order } =
      String.to_charlist(to_rotate)
      |> Enum.map(
        fn char -> 
          rotate_char(Map.get(rotate_map, [char]), [char]) end
        )
      |> reorder_cubicle
    { String.to_atom(rotated_char_list), new_order, rotate_map }
  end

  def rotate_f2l_cubicle(to_rotate, corner) do
    Atom.to_string(to_rotate)
    |> rotate_cubicle(get_rotate_map(corner))
  end

  def rotate_cubie(to_rotate, rotation, rotate_map) do
    String.to_charlist(to_rotate)
      |> Enum.map(
        fn char -> 
          rotate_char(Map.get(rotate_map, [char]), [char]) end
        )
      |> List.to_string
      |> rotate_corner_or_edge(
        rotation, 
        String.length(to_rotate)
      )
  end

  def rotate_initial_state_f2l(initial_state, [corner, _], _face) do
    Enum.reduce(initial_state, %{},
      fn ({cubicle, cubie}, result_map) ->
        { new_cubicle, rotation, rotate_map } = 
        rotate_f2l_cubicle(cubicle, corner)

        Map.put(
          result_map, 
          new_cubicle, 
          rotate_cubie(cubie, rotation, rotate_map)
        )
      end
    )
  end

  def rotate_moves(moves, rotate_map) do
    Enum.map(
      moves,
      fn move_str -> 
        String.to_charlist(move_str)
        |> Enum.map(
          fn char -> 
            rotate_char(Map.get(rotate_map, [char]), [char]) end
          )
        |> List.to_string
      end
    )
  end

end
