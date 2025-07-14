defmodule Pusher.Controller do
  use OpenApiSpex.ControllerSpecs
  use Phoenix.Controller

  alias Phoenix.PubSub
  alias Pusher.PushSocket
  alias Pusher.Token
  alias Pusher.APISpec
  require Logger
  import Plug.Conn

  action_fallback Pusher.FallbackController
  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

  operation :healthcheck,
    summary: "Just returns 200 OK",
    responses: [
      ok: {"OK", "text/plain", APISpec.HealthcheckResponse}
    ]

  def healthcheck(conn, _) do
    send_resp(conn, 200, "OK")
  end

  operation :websocket,
    summary: "Connects to user websocket",
    description:
      "Upgrades the connection to websocket and starts sending events for the given user",
    security: [%{"authorization" => ["listen:pushes"]}],
    responses: [
      switching_protocols: {"Response", "", %OpenApiSpex.Schema{}},
      forbidden: {"Response", "text/plain", APISpec.HealthcheckResponse}
    ]

  def websocket(conn, _param) do
    with {:ok, user_id} <- validate_websocket(conn) do
      conn
      |> WebSockAdapter.upgrade(PushSocket, %{user_id: user_id}, timeout: 60_000)
      |> halt()
    end
  end

  operation :push,
    summary: "Pushes a message to all connected users",
    security: [%{"authorization" => ["push:pushes"]}],
    request_body: {"Push params", "application/json", APISpec.PushParams, required: true},
    responses: [
      ok: {"Pushed", "text/plain", APISpec.PushResponse.response("OK")},
      forbidden: {"Forbidden", "text/plain", APISpec.PushResponse.response("Forbidden")}
    ]

  def push(conn, _params) do
    with :ok <- validate_control(conn) do
      %APISpec.PushParams{body: body, userId: user_id} = conn.private.open_api_spex.body_params
      PubSub.broadcast(:user_sockets, "user:#{user_id}", {:push, {:text, body}})
      send_resp(conn, 200, "OK")
    end
  end

  defp validate_control(conn) do
    Enum.find_value(conn.req_headers, {:error, :bad_secret}, fn
      {"authorization", "Bearer " <> secret} ->
        Token.validate_secret(secret)

      _ ->
        nil
    end)
  end

  defp validate_websocket(conn) do
    Enum.find_value(conn.req_headers, {:error, :bad_token}, fn
      {"authorization", "Bearer " <> token} ->
        Token.validate_token(token)

      _ ->
        nil
    end)
  end
end
