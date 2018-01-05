defmodule ContactWeb.Router do
  use ContactWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json-api"]
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  pipeline :api_auth do
    plug ContactWeb.Guardian.AuthPipeline
  end

  scope "/", ContactWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", ContactWeb.Api do
    pipe_through :api

    scope "/v1", V1 do
      resources "/users", UserController, only: [:create]
      post "/users/sign_in", UserController, :sign_in
    end
  end

  scope "/api", ContactWeb.Api do
    pipe_through [:api, :api_auth]

    scope "/v1", V1 do
      resources "/users", UserController, only: [:update, :show, :delete]
      resources "/teams", TeamController, only: [:create, :update, :delete, :show]
    end
  end
end
