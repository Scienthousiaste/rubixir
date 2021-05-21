defmodule Rubik.Solver.OLL do

  alias Rubik.Solver.Helpers
  @max_iter_solve_oll 1

  def oll_goal_state(face) do
  end

  defp oll_completed?(cube, face) do
  end

  defp loop_solve_oll(solver_data, _, _f2l_complete = true) do
    IO.puts "solve_oll is done"
    solver_data
  end
  defp loop_solve_oll(solver_data, _n_iter = 0, _f2l_complete = false) do
    IO.puts "Loop solve oll failed to finish"
    solver_data
  end
  defp loop_solve_oll(solver_data, iter, _f2l_complete = false) do
    loop_solve_oll(solver_data, iter - 1,
      oll_completed?(solver_data.cube, solver_data.base_face)
    )
  end

  def solve_oll( solver_data = %{ cube: cube, base_face: face } ) do
    loop_solve_oll(
      solver_data,
      @max_iter_solve_f2l,
      oll_completed?(cube, face)
    )
  end

end
