defmodule Pusher.ErrorView do
  def render(template, _assigns) do
    if String.ends_with?(template, ".html") do
      Phoenix.Controller.status_message_from_template(template)
    else
      %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
    end
  end
end

defmodule Phoenix.HTML.Engine do
  def encode_to_iodata!(anything) do
    Jason.encode!(anything)
  end
end
