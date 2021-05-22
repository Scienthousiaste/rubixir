defmodule Rubik.Solver.OLL do
  alias Rubik.Solver.Helpers

  defp repeat_string(string, 1), do: string <> string 
  defp repeat_string(string, n), do: repeat_string(string <> string, n - 1)
  defp oll_goal_state(face) do
    Helpers.opposite_face(face)
    |> Atom.to_string
    |> repeat_string(3)
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

  defp moves_from_rotation_plus_algo(_, nil), do: nil
  defp moves_from_rotation_plus_algo(move, algo) do
    [move] ++ algo.moves
  end

  defp do_find_moves(nil, %{ cube: cube, base_face: face },
    oll_algo_map) do

    Enum.find_value(
      Rubik.Solver.Helpers.opposite_face_moves(face),
      fn move ->
        moves_from_rotation_plus_algo(
          move,
          Map.get(
            oll_algo_map, 
            oll_status(Rubik.Transforms.qturn(cube, move), face)
          )
        )
      end
    )
  end 
  defp do_find_moves(%Rubik.Algorithm{moves: moves}, _, _) do
    moves 
  end 
  
  defp find_oll_algo(oll_algo_map, 
    solver_data = %{ cube: cube, base_face: face } ) do 
    do_find_moves(
      Map.get(oll_algo_map, oll_status(cube, face)),
      solver_data,
      oll_algo_map
    )
  end

  defp apply_oll_algo(nil, solver_data) do
    solver_data
  end
  defp apply_oll_algo(moves, solver_data) do
    Helpers.update_solver_data(moves, solver_data)
  end

  def solve_oll( solver_data = %{ base_face: face } ) do
    oll_algo_map = Rubik.OLL.Algorithms.get_oll_algo_map(face)
    find_oll_algo(oll_algo_map, solver_data)
    |> apply_oll_algo(solver_data)
  end

end
