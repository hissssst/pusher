defmodule Pusher.PushSocket do
  alias Phoenix.PubSub

  def init(%{user_id: user_id}) do
    :erlang.garbage_collect()
    PubSub.subscribe(:user_sockets, "user:#{user_id}")
    state = %{user_id: user_id}
    {:ok, state}
  end

  def handle_info({:push, messages}, state) do
    {:push, messages, state}
  end
end
