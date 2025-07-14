defmodule Pusher.FallbackController do
  use Phoenix.Controller
  import Plug.Conn

  def call(conn, {:error, error}) when error in ~w[bad_secret bad_token]a do
    send_resp(conn, 403, "Forbidden")
  end
end
