defmodule VisuWeb.Router do
  use VisuWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VisuWeb do
    pipe_through :browser

    get "/", RubikController, :init_rubik

    post "/", RubikController, :init_rubik
    post "/move/:move", RubikController, :make_move
    post "/scrambled", RubikController, :get_scrambled_cube
    post "/solve_cross", RubikController, :solve_cross
  end

end
