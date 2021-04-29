defmodule VisuWeb.RubikController do
  use VisuWeb, :controller

  def solve_cross(conn, _params) do
    solver_data = Rubik.solve_cube(get_session(conn, :cube))
    cube = solver_data.cube
    conn
    |> put_session(:cube, cube)
    |> render("rubik.html", cube: cube)
  end

  def get_scrambled_cube(conn, _params) do
    cube = Rubik.scrambled_cube()
    conn
    |> put_session(:cube, cube)
    |> render("rubik.html", cube: cube)
  end
  
  def init_rubik(conn, _params) do
    cube = Rubik.new_cube()
    conn
    |> put_session(:cube, cube)
    |> render("rubik.html", cube: cube)
  end

  def make_move(conn, %{"move" => move}) do
    cube = Rubik.qturn(get_session(conn, :cube), move)
    conn
    |> put_session(:cube, cube)
    |> render("rubik.html", cube: cube)
  end

end
