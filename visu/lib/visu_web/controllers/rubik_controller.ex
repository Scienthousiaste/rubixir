defmodule VisuWeb.RubikController do
  use VisuWeb, :controller
  
  def init_rubik(conn, _params) do
    cube = Rubik.new_cube()
    conn
    |> put_session(:cube, cube)
    |> render("rubik.html", cube: cube)
  end

 end
