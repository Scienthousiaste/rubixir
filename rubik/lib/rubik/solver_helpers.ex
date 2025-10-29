defmodule Rubik.Solver.Helpers do
  def cubicle_to_expected_cubie(cubicle) do
    String.downcase(Atom.to_string(cubicle))
  end

  def is_cubie_permutation?(goal, actual) do
    MapSet.equal?(
      MapSet.new(String.to_charlist(cubicle_to_expected_cubie(goal))),
      MapSet.new(String.to_charlist(actual))
    )
  end

  def opposite_face(face) do
    Map.get(
      %{
        F: :B,
        B: :F,
        R: :L,
        L: :R,
        U: :D,
        D: :U
      },
      face
    )
  end

  def opposite_face_moves(face) do
    opposite_face(face) |> Rubik.Cube.face_moves()
  end

  def find_where_target_is(cube, target) do
    {target_cubicle, _} =
      Enum.find(
        cube,
        fn {_cubicle, content} ->
          is_cubie_permutation?(target, content)
        end
      )

    target_cubicle
  end

  def is_in_opposite_face?(position, face) do
    String.contains?(
      Atom.to_string(position),
      Atom.to_string(opposite_face(face))
    )
  end

  def goal_reached?(cube, goal_state) do
    Enum.all?(goal_state, fn cubie ->
      String.upcase(Map.get(cube, cubie)) == Atom.to_string(cubie)
    end)
  end

  def moves_from_face(face) do
    face_str = Atom.to_string(face)
    [face_str, face_str <> "'", face_str <> "2"]
  end

  def get_mirror_of_cubicle_in_face(cubicle, face) do
    String.to_atom(
      String.replace(
        Atom.to_string(cubicle),
        Atom.to_string(opposite_face(face)),
        Atom.to_string(face)
      )
    )
  end

  def update_solver_data([], solver_data) do
    solver_data
  end

  def update_solver_data(move_sequence, solver_data) do
    %{
      solver_data
      | cube: Rubik.Transforms.qturns(solver_data.cube, move_sequence),
        moves: solver_data.moves ++ move_sequence
    }
  end

  def update_solver_data([], solver_data, _) do
    solver_data
  end

  def update_solver_data(move_sequence, solver_data, [goal1, goal2]) do
    # F2L
    %{
      solver_data
      | cube: Rubik.Transforms.qturns(solver_data.cube, move_sequence),
        progress: solver_data.progress ++ [goal1, goal2],
        moves: solver_data.moves ++ move_sequence
    }
  end

  def update_solver_data(move_sequence, solver_data, goal) do
    # Cross goal
    %{
      solver_data
      | cube: Rubik.Transforms.qturns(solver_data.cube, move_sequence),
        progress: solver_data.progress ++ [goal],
        moves: solver_data.moves ++ move_sequence
    }
  end
end
