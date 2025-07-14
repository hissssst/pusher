defmodule Pusher.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: :user_sockets},
      Pusher.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Pusher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
