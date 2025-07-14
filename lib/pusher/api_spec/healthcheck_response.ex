defmodule Pusher.APISpec.HealthcheckResponse do
  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "HealthcheckResponse",
    description: "Response schema for health check",
    type: :string,
    example: "OK"
  })
end
