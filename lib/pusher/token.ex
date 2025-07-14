defmodule Pusher.Token do
  use Joken.Config

  @user_id_key "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"

  def new_user_token(user_id) do
    generate_and_sign!(%{@user_id_key => user_id})
  end

  def validate_token(token) do
    case verify_and_validate(token) do
      {:ok, %{@user_id_key => user_id}} ->
        {:ok, user_id}

      {:ok, _} ->
        {:error, :bad_token}

      {:error, _reason} ->
        {:error, :bad_token}
    end
  end

  def validate_secret(received) do
    expected = Application.fetch_env!(:pusher, :control_secret)

    cond do
      byte_size(received) != byte_size(expected) ->
        {:error, :bad_secret}

      :crypto.hash_equals(expected, received) ->
        :ok

      true ->
        {:error, :bad_secret}
    end
  end
end
