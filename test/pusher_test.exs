defmodule PusherTest do
  use Pusher.ConnCase
  alias Pusher.WebsocketClient

  @moduletag capture_log: true

  setup do
    {:ok, user_id: Integer.to_string(:erlang.unique_integer([:positive]))}
  end

  test "sends the message", %{conn: conn, user_id: user_id} do
    client = WebsocketClient.new(4000, user_id, self())

    assert_receive {:websocket, ^client, :connected}, 1_000

    assert "OK" ==
      conn
      |> put_req_header("content-type", "application/json")
      |> put_req_header("authorization", "Bearer #{Application.fetch_env!(:pusher, :control_secret)}")
      |> post(~p"/api/push", %{"userId" => user_id, "body" => "hello"})
      |> response(200)

    assert_receive {:websocket, ^client, {:text, "hello"}}
  end

  @tag amount: 10
  test "sends the message to multiple sockets", %{conn: conn, amount: n, user_id: user_id} do
    clients =
      for _ <- 1..n do
        WebsocketClient.new(4000, user_id, self())
      end

    for client <- clients do
      assert_receive {:websocket, ^client, :connected}, 1_000
    end

    assert "OK" ==
      conn
      |> put_req_header("content-type", "application/json")
      |> put_req_header("authorization", "Bearer #{Application.fetch_env!(:pusher, :control_secret)}")
      |> post(~p"/api/push", %{"userId" => user_id, "body" => "hello"})
      |> response(200)

    for client <- clients do
      assert_receive {:websocket, ^client, {:text, "hello"}}
    end
  end
end
