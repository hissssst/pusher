defmodule Pusher.APISpec.PushResponse do
  def response(example) do
    %OpenApiSpex.Schema{
      title: "PushResponse",
      description: "Response schema for push operation",
      type: :string,
      example: example
    }
  end
end
