defmodule VisuWeb.RubikController do
  use VisuWeb, :controller
  
  def init_rubik(conn, _params) do
    conn
    |> render("rubik.html", cube: Rubik.new_cube())
  end

  def landing_page(conn, _params) do
    conn
    |> render("landing_page.html")
  end

 end
