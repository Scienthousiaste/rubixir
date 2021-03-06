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

    
    get "/", RubikController, :landing_page
    get "/rubik", RubikController, :init_rubik
  end

end
