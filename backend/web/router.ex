defmodule Casper.Router do
  use Casper.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug PlugCors, [origins: ["*"]]
  end

  scope "/", Casper do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Casper do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/posts", PostController, except: [:new, :edit]
    end
  end
end
