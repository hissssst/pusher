defmodule Pusher.Endpoint do
  use Phoenix.Endpoint, otp_app: :pusher

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason

  plug Pusher.Router
end
