defmodule Pusher.Router do
  use Phoenix.Router

  pipeline :api do
    plug OpenApiSpex.Plug.PutApiSpec, module: Pusher.APISpec
  end

  scope "/api" do
    pipe_through :api

    get "/websocket", Pusher.Controller, :websocket

    get "/healthcheck", Pusher.Controller, :healthcheck

    post "/push", Pusher.Controller, :push

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []

    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end
end
