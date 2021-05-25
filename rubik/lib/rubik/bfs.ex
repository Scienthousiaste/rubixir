defmodule Rubik.BFS do

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

  defp goal_reached_with_moves?(move_sequence, cube, goal_state) do
    Enum.all?(
      goal_state,
      fn {cubicle, cubie} ->
        Rubik.Transforms.qturns(cube, move_sequence)
        |> Map.get(cubicle) == cubie
      end
    )
  end

  def reach_goal_cross(solver_data = %{cube: cube}, current_goal, max_depth) do
    goal_state = solver_data.progress ++ [current_goal]
    Enum.find(
      get_move_sequences_to_explore(max_depth),
      [],
      fn move_sequence ->
        goal_reached_with_moves?(move_sequence, cube, goal_state) 
      end
    )
  end

end
