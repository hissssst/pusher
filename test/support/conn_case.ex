defmodule Pusher.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint Pusher.Endpoint

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import unquote(__MODULE__)

      use Phoenix.VerifiedRoutes,
        endpoint: Pusher.Endpoint,
        router: Pusher.Router
    end
  end

  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end


