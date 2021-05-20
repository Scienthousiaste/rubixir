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
end
