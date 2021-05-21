defmodule VisuWeb.RubikChannel do

  use Phoenix.Channel

  def join("rubik:cube", _, socket) do
    cube = Rubik.scrambled_cube()
    socket = assign(socket, :cube, cube)
    { :ok, socket }
  end

  def handle_in("make_move", params, socket) do
    cube = Rubik.qturn(socket.assigns.cube, params["move"])
    socket = assign(socket, :cube, cube)
    push(socket, "move", %{move: params["move"], cube: Map.from_struct(cube)})
    { :noreply, socket }
  end

  def handle_in("get_solved_cube", _params, socket) do

    #cube = Rubik.new_cube()

    cross = %{
      DF: "df",
      DR: "dr",
      DL: "dl",
      DB: "db",
      UR: "lf",
      ULF: "fld"
    }

    cube = Rubik.cube_test(cross)

    socket = assign(socket, :cube, cube)

    #push(socket, "new_cube", %{cube: Map.from_struct(cube)})
    push(socket, "new_cube", %{cube: Map.from_struct(cube)})

    { :noreply, socket }
  end

  def handle_in("get_scrambled_cube", _params, socket) do
    cube = Rubik.scrambled_cube()
    socket = assign(socket, :cube, cube)
    push(socket, "new_cube", %{cube: Map.from_struct(cube)})
    { :noreply, socket }
  end

  def handle_in("solve_cross", _params, socket) do
    %{cube: cube, moves: moves} = Rubik.solve_cube(socket.assigns.cube)
    socket = assign(socket, :cube, cube)
    push(socket, "move_sequence", %{moves: moves, type: "cross"})
    { :noreply, socket }
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
    socket = assign(socket, :cube, cube)
    push(socket, "move_sequence", %{moves: move_sequence})
    { :noreply, socket }
  end 

  def handle_in(_, _, socket) do
    push(socket, "error", "No corresponding event")
    { :noreply, socket }
  end

end

