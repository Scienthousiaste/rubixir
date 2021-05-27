defmodule VisuWeb.RubikChannel do

  use Phoenix.Channel

  def assign_and_push_cube(cube, socket, message, map_to_push) do
    socket = assign(socket, :cube, cube)
    push(socket, message, map_to_push)
    { :noreply, socket }
  end
  def assign_and_push_cube(cube, socket, message) do
    socket = assign(socket, :cube, cube)
    push(socket, message, %{cube: Map.from_struct(cube)})
    { :noreply, socket }
  end

  def join("rubik:cube", _, socket) do
    cube = Rubik.new_cube()
    socket = assign(socket, :cube, cube)
    { :ok, socket }
  end

  def handle_in("make_move", params, socket) do
    cube = Rubik.qturn(socket.assigns.cube, params["move"])
    params = %{move: params["move"], cube: Map.from_struct(cube)}
    assign_and_push_cube(cube, socket, "move", params)
  end

  def handle_in("get_solved_cube", _params, socket) do
    cube = Rubik.new_cube()
    assign_and_push_cube(cube, socket, "new_cube")
  end

  def handle_in("get_scrambled_cube", _params, socket) do
    cube = Rubik.scrambled_cube()
    assign_and_push_cube(cube, socket, "new_cube")
  end

  def handle_in("solve_cube", _params, socket) do
    %{cube: cube, moves: moves} = Rubik.solve_cube(socket.assigns.cube)
    assign_and_push_cube(cube, socket, "move_sequence", %{moves: moves, type: "solve"})
  end

  def handle_in("solve_cross", _params, socket) do
    %{cube: cube, moves: moves} = Rubik.solve_cross(socket.assigns.cube)
    assign_and_push_cube(cube, socket, "move_sequence", %{moves: moves, type: "solve"})
  end

  def handle_in("solve_f2l", _params, socket) do
    %{cube: cube, moves: moves} = Rubik.solve_f2l(socket.assigns.cube)
    assign_and_push_cube(cube, socket, "move_sequence", %{moves: moves, type: "solve"})
  end

  def handle_in("solve_oll", _params, socket) do
    %{cube: cube, moves: moves} = Rubik.solve_oll(socket.assigns.cube)
    assign_and_push_cube(cube, socket, "move_sequence", %{moves: moves, type: "solve"})
  end

  def handle_in("move_sequence", params, socket) do
    move_sequence = String.split(params["move_sequence"], " ")
    cube = Rubik.qturns(socket.assigns.cube, move_sequence)
    socket = assign(socket, :cube, cube)
    push(socket, "move_sequence", %{moves: move_sequence})
    { :noreply, socket }
  end

  def handle_in("pattern", _params = %{ "pattern" => pattern }, socket) do
    move_sequence = Channel.Helpers.get_pattern(pattern)
    cube = Rubik.qturns(socket.assigns.cube, move_sequence)
    assign_and_push_cube(cube, socket, "move_sequence", %{moves: move_sequence})
  end 

  def handle_in(_, _, socket) do
    push(socket, "error", "No corresponding event")
    { :noreply, socket }
  end

end

