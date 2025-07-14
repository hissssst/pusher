defmodule Pusher.WebsocketClient do
  use Fresh

  def new(port, user_id, notify) do
    token = Pusher.Token.new_user_token(user_id)
    headers = [{"authorization", "Bearer #{token}"}]
    {:ok, socket} = start_link(uri: "ws://localhost:#{port}/api/websocket", state: notify, opts: [headers: headers])
    socket
  end

  def handle_connect(_, _, notify) do
    send(notify, {:websocket, self(), :connected})
    {:ok, notify}
  end

  def handle_control(_message, state) do
    {:ok, state}
  end

  def handle_in(message, state) do
    send(state, {:websocket, self(), message})
    {:ok, state}
  end

  def handle_error(_, _) do
    :close
  end

  def handle_disconnect(_, _, _) do
    :close
  end
end
