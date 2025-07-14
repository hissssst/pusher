defmodule Pusher.APISpec do
  alias OpenApiSpex.{Components, Info, OpenApi, Paths, Server, SecurityScheme}
  alias Pusher.Endpoint
  alias Pusher.Router

  @behaviour OpenApi

  @version (if function_exported?(Pusher.MixProject, :version, 0) do
              Pusher.MixProject.version()
            else
              "undefined"
            end)

  def spec do
    %OpenApi{
      info: %Info{title: "Pusher", version: @version},
      servers: [Server.from_endpoint(Endpoint)],
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{"authorization" => %SecurityScheme{type: "http", scheme: "bearer"}}
      }
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
