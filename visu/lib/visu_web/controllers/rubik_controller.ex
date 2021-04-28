defmodule VisuWeb.RubikController do
  use VisuWeb, :controller

  def rubik(conn, _params) do

    cube = Rubik.scrambled_cube()

    conn
    |> put_session(:cube, cube)
    |> render("rubik.html", cube: cube)
  end
end
