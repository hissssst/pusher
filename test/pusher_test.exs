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
             |> put_req_header(
               "authorization",
               "Bearer #{Application.fetch_env!(:pusher, :control_secret)}"
             )
             |> post(~p"/api/push", %{"userId" => user_id, "body" => "hello"})
             |> response(200)

    assert_receive {:websocket, ^client, {:text, "hello"}}, 1_000
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
             |> put_req_header(
               "authorization",
               "Bearer #{Application.fetch_env!(:pusher, :control_secret)}"
             )
             |> post(~p"/api/push", %{"userId" => user_id, "body" => "hello"})
             |> response(200)

    for client <- clients do
      assert_receive {:websocket, ^client, {:text, "hello"}}, 1_000
    end
  end

  test "Fails on incorrect JWT" do
    token = "invalid"
    headers = [{"authorization", "Bearer #{token}"}]

    {:ok, client} =
      WebsocketClient.start_link(
        uri: "ws://localhost:4000/api/websocket",
        state: self(),
        opts: [headers: headers]
      )

    refute_receive {:websocket, ^client, :connected}, 1_000
  end

  test "Fails on incorrect secret", %{conn: conn} do
    assert "Forbidden" ==
             conn
             |> put_req_header("content-type", "application/json")
             |> put_req_header("authorization", "Bearer invalid")
             |> post(~p"/api/push", %{"userId" => "1234", "body" => "hello"})
             |> response(403)
  end

  test "Fails on incorrect params", %{conn: conn} do
    conn
    |> put_req_header("content-type", "application/json")
    |> put_req_header("authorization", "Bearer invalid")
    |> post(~p"/api/push", %{"userId" => 1234, "body" => "hello"})
    |> response(422)
  end
end
