defmodule Rubik.Solver.OLL do
  alias Rubik.Solver.Helpers
  
  def oll_goal_state(face) do
    #TODO faire avec face
    "UUUUUUUU"
  end

  def oll_completed?(cube, face) do
    oll_status(cube, face) == oll_goal_state(face)
  end

  def string_letter_from_index(nil, _), do: "_"
  def string_letter_from_index(index, cubicle) do
    Atom.to_string(cubicle)
    |> String.at(index)
  end

  def position_opposite_face(cubie, cubicle, face) do
    face_letter = Atom.to_string(face)
    |> String.downcase
    |> String.to_charlist

    string_letter_from_index(
      Enum.find_index(String.to_charlist(cubie),
        fn char ->
          [char] == face_letter
        end
      ),
      cubicle
    )
  end

  def oll_status(cube, face) do
    opposite_face = Helpers.opposite_face(face)
    Enum.reduce(
      Rubik.Cube.face_cubicles(opposite_face),
      "",
      fn cubicle, status_result ->
        status_result <>
        position_opposite_face(
          Map.get(cube, cubicle),
          cubicle,
          opposite_face
        )
      end
    )
  end

  def solve_oll( solver_data = %{ cube: cube, base_face: face } ) do
    IO.puts oll_status(cube, face)

    oll_algo_map = Rubik.OLL.Algorithms.get_oll_algo_map(face)
    IO.inspect oll_algo_map

    solver_data
  end

end
