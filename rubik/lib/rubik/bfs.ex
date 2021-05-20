defmodule Rubik.BFS do
  alias Rubik.Cube

  def get_move_sequences(4) do
    for a <- Rubik.Cube.moves(),
        b <- Rubik.Cube.moves(),
        c <- Rubik.Cube.moves(),
        d <- Rubik.Cube.moves() do
      [a, b, c, d]
    end
  end

  def get_move_sequences(3) do
    for a <- Rubik.Cube.moves(),
        b <- Rubik.Cube.moves(),
        c <- Rubik.Cube.moves() do
      [a, b, c]
    end
  end
  
  def get_move_sequences(2) do
    for a <- Rubik.Cube.moves(), b <- Rubik.Cube.moves() do
      [a, b]
    end
  end
  def get_move_sequences(1) do
    Enum.map(Rubik.Cube.moves(), fn x -> [x] end)
  end

  def get_move_sequences_to_explore(0) do
    [] 
  end
  def get_move_sequences_to_explore(depth) do
    get_move_sequences_to_explore(depth - 1) ++ get_move_sequences(depth)
  end

  def reach_goal(solver_data, goal, max_depth) do
    goal_state = solver_data.progress ++ [goal]

    Enum.find(get_move_sequences_to_explore(max_depth), [],
      fn move_sequence ->
        Rubik.Solver.Helpers.goal_reached?(
          Rubik.Transforms.qturns(solver_data.cube, move_sequence),
          goal_state
        )
      end
    )
  end

  defp get_cancel_move(move, 2), do: String.at(move, 0)
  defp get_cancel_move(move, 1), do: move <> "'"
  defp canceling_move(move) do
    get_cancel_move(move, String.length(move)) 
  end

  defp get_f2l_pre_algo_move_sequences([], [], face) do
    []
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

  def reach_f2l_pre_algo_state(_, _, [], []) do
    IO.inspect "nothing to do in reach f2l_pre_algo"
    []
  end
  def reach_f2l_pre_algo_state(solver_data = %{base_face: face},
    f2l_goal, corner_move, edge_move) do

    result_reach = Enum.find(get_f2l_pre_algo_move_sequences(corner_move, edge_move,
      face),
      fn move_sequence -> 
        Rubik.Solver.F2L.PlaceGoalDuo.f2l_algo_state?(
          Rubik.Transforms.qturns(solver_data.cube, move_sequence), 
          f2l_goal
        )
      end
    )

    IO.inspect ["result_reach algo state", result_reach]
    result_reach
  end

end
