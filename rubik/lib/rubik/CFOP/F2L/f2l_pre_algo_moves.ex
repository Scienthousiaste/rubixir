defmodule Rubik.PreAlgo do
  alias Rubik.Cube

  defp get_cancel_move(move, 2), do: String.at(move, 0)
  defp get_cancel_move(move, 1), do: move <> "'"
  defp canceling_move(move) do
    get_cancel_move(move, String.length(move)) 
  end

  defp get_f2l_pre_algo_move_sequences([], [], face) do
    opp_face_moves = Rubik.Solver.Helpers.opposite_face(face)
    |> Cube.face_moves()
    for a <- opp_face_moves do
      [a]
    end
  end
  defp get_f2l_pre_algo_move_sequences([], edge_move, face) do
    opp_face_moves = Rubik.Solver.Helpers.opposite_face(face)
    |> Cube.face_moves()
    for a <- edge_move,
        b <- opp_face_moves do
        [a, b, canceling_move(a)]
    end 
  end
  defp get_f2l_pre_algo_move_sequences(corner_move, [], face) do
    opp_face_moves = Rubik.Solver.Helpers.opposite_face(face)
    |> Cube.face_moves()
    for a <- corner_move,
        b <- opp_face_moves,
        d <- opp_face_moves do
        [a, b, canceling_move(a), d]
    end
  end
  defp get_f2l_pre_algo_move_sequences(corner_move, edge_move, face) do
    opp_face_moves = Rubik.Solver.Helpers.opposite_face(face)
    |> Cube.face_moves()
    for a <- corner_move,
        b <- opp_face_moves,
        d <- edge_move,
        e <- opp_face_moves,
        g <- opp_face_moves do
        [a, b, canceling_move(a), d, e, canceling_move(d), g]
    end
  end

  def find_move_sequences_f2l_if_required(_done = true, _, _, _, _) do
    []
  end
  def find_move_sequences_f2l_if_required(_,
    solver_data = %{base_face: face, cube: cube},
    f2l_goal, corner_move, edge_move) do

    Enum.find(get_f2l_pre_algo_move_sequences(corner_move, edge_move,
      face),
      fn move_sequence -> 
        Rubik.Solver.F2L.PlaceGoalDuo.f2l_algo_state?(
          Rubik.Transforms.qturns(solver_data.cube, move_sequence), 
          f2l_goal,
          face
        )
      end
    )
  end

  def reach_f2l_pre_algo_state(solver_data = %{base_face: face, cube: cube},
    f2l_goal, corner_move, edge_move) do
    find_move_sequences_f2l_if_required(
      Rubik.Solver.F2L.PlaceGoalDuo.f2l_algo_state?(cube, f2l_goal, face),
      solver_data, f2l_goal, corner_move, edge_move
    )
  end

end
