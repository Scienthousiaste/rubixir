defmodule VisuWeb.RubikChannel do

  use Phoenix.Channel

  def join("rubik:cube", _, socket) do
    cube = Rubik.new_cube()
    socket = assign(socket, :cube, cube)
    { :ok, socket }
  end

  def handle_in("make_move", params, socket) do
    cube = Rubik.qturn(socket.assigns.cube, params["move"])
    # IL FAUT RECUP EN CAS D'ERREUR DU QTURN
    # - MAJ data-cube (front ?)
    # - lancer l'animation du cube (front)

    socket = assign(socket, :cube, cube)
    push(socket, "move", %{move: params["move"], cube: Map.from_struct(cube)})
    { :noreply, socket }
  end

  def handle_in("get_cube", _params, socket) do
    cube = Rubik.new_cube()
    socket = assign(socket, :cube, cube)
    { :noreply, socket }
  end

  def handle_in(_, _, socket) do
    push(socket, "error", "no corresponding event")
    { :noreply, socket }
  end

end


#  def solve_cross(conn, _params) do
#    solver_data = Rubik.solve_cube(get_session(conn, :cube))
#    cube = solver_data.cube
#    conn
#    |> put_session(:cube, cube)
#    |> render("rubik.html", cube: cube)
#
#
#  def get_scrambled_cube(conn, _params) do
#    cube = Rubik.scrambled_cube()
#    conn
#    |> put_session(:cube, cube)
#    |> render("rubik.html", cube: cube)
#  end
#  
#  def init_rubik(conn, _params) do
#    cube = Rubik.new_cube()
#    conn
#    |> put_session(:cube, cube)
#    |> render("rubik.html", cube: cube)
#  end
#
#
#  def cube_in_cube_pattern(conn, _params) do
#    cube = Rubik.qturns(Rubik.new_cube(), [
#      "U'", "L'", "U'", "F'", "R2", "B'", "R", "F", "U", "B2", 
#      "U", "B'", "L", "U'", "F", "U", "R", "F'"
#    ])
#
#    conn
#    |> put_session(:cube, cube)
#    |> render("rubik.html", cube: cube)
#  end
#
