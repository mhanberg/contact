defmodule ContactWeb.Api.V1.Room.MessageView do
  use ContactWeb, :view
  alias ContactWeb.Api.V1.MessageSerializer

  def render("index.json-api", %{messages: messages}) do
    MessageSerializer
    |> JaSerializer.format(messages)
  end
end
