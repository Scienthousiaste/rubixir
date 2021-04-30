defmodule VisuWeb.RubikChannel do

  use Phoenix.Channel

  def join("rubik:cube", _, socket) do
    cube = Rubik.new_cube()
    socket = assign(socket, :cube, cube)
    { :ok, socket }
  end

  def handle_in("make_move", _params, socket) do
    cube = socket.assigns.cube
    IO.inspect cube
    #make move, re push le new cube dans la socket
    #push(socket, "new_cube"..)
    { :noreply, socket }
  end

  def handle_in("get_cube", _params, socket) do
    cube = Rubik.new_cube()
    socket = assign(socket, :cube, cube)
    { :noreply, socket }
  end

  def handle_in(_, _, socket) do
    push(socket, "error", "no corresponding event")
    { "noreply", socket }
  end


end
