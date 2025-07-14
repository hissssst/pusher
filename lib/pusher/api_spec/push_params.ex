defmodule Pusher.APISpec.PushParams do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "PushParams",
    description: "Object of parameters for push operation",
    type: :object,
    required: [:userId, :body],
    properties: %{
      userId: %Schema{type: :string, description: "User UUID"},
      body: %Schema{type: :string, description: "Message to send"}
    },
    example: %{
      "userId" => "0cc51114-75a6-1ab8-1eab-311f7011eadd",
      "body" => "Hello!"
    }
  })
end
