defmodule VisuWeb.RubikController do
  use VisuWeb, :controller
  
  def init_rubik(conn, _params) do
    conn
    |> render("rubik.html", cube: Rubik.new_cube())
  end

 end
