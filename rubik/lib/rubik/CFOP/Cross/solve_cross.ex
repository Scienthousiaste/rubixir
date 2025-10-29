defmodule Rubik.Solver.Cross do
  alias Rubik.Solver.Helpers
  alias Rubik.Solver.AlgoHelpers
  @max_iter_solve_cross 5
  @max_moves_per_bfs_search 4

  defp find_next_cross_goal(
         solver_data = %{cube: cube, base_face: face, starting_point: starting_point}
       ) do
    goal =
      Enum.find(
        Enum.zip(
          Rubik.Cube.edges(face),
          cross_goal_state(starting_point, face)
        ),
        fn {cubicle, cubie} ->
          cubie != Map.get(cube, cubicle)
        end
      )

    {solver_data, goal}
  end

  defp reorient_cross_move(starting_point) do
    # When cross is done with "dl" in the starting_point cubicle, 
    # what move is required to reorient the cross?
    Map.get(
      %{
        DL: [],
        DF: ["D'"],
        DR: ["D2"],
        DB: ["D"]
      },
      starting_point
    )
  end

  defp complete_cross_goal({solver_data = %{starting_point: starting_point}, nil}) do
    Helpers.update_solver_data(
      reorient_cross_move(starting_point),
      solver_data
    )
  end

  defp complete_cross_goal({solver_data, goal}) do
    Rubik.BFS.reach_goal_cross(
      solver_data,
      goal,
      @max_moves_per_bfs_search
    )
    |> Helpers.update_solver_data(solver_data, goal)
  end

  def expected_cross_cubie(edge, starting_point) do
    rotate_map = AlgoHelpers.get_rotate_map(starting_point)

    {cubicle, _, _} =
      AlgoHelpers.rotate_cubicle(
        Atom.to_string(edge),
        rotate_map
      )

    Helpers.cubicle_to_expected_cubie(cubicle)
  end

  defp add_to_progress_if_done(_done = true, progress, edge, value) do
    progress ++ [{edge, value}]
  end

  defp add_to_progress_if_done(_done = false, progress, _, _), do: progress

  def compute_cross_progress(cube, base_face, starting_point) do
    Enum.reduce(
      Rubik.Cube.edges(base_face),
      [],
      fn cross_edge, list_progress ->
        current_edge_value = Map.get(cube, cross_edge)

        add_to_progress_if_done(
          current_edge_value == expected_cross_cubie(cross_edge, starting_point),
          list_progress,
          cross_edge,
          current_edge_value
        )
      end
    )
  end

  def cross_goal_state(starting_point, face) do
    Enum.map(
      Rubik.Cube.edges(face),
      fn edge -> expected_cross_cubie(edge, starting_point) end
    )
  end

  def cross_goal_state(face) do
    Enum.map(
      Rubik.Cube.edges(face),
      fn edge -> Helpers.cubicle_to_expected_cubie(edge) end
    )
  end

  defp cross_state(cube, face) do
    Enum.map(
      Rubik.Cube.edges(face),
      fn edge -> Map.get(cube, edge) end
    )
  end

  defp cross_edges_placed?(cube, face) do
    cross_state(cube, face) == cross_goal_state(face)
  end

  defp loop_solve_cross(solver_data, _, _cross_edges_placed = true) do
    solver_data
  end

  defp loop_solve_cross(solver_data, _n_iter = 0, _cross_edges_placed = false) do
    IO.puts("Loop solve cross failed to finish")
    IO.inspect(solver_data)
    solver_data
  end

  defp loop_solve_cross(solver_data, iter, false) do
    sd =
      find_next_cross_goal(solver_data)
      |> complete_cross_goal

    loop_solve_cross(sd, iter - 1, cross_edges_placed?(sd.cube, sd.base_face))
  end

  def solve_cross(solver_data = %{cube: cube, base_face: face}) do
    loop_solve_cross(
      solver_data,
      @max_iter_solve_cross,
      cross_edges_placed?(cube, face)
    )
  end
end
