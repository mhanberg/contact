defmodule ContactWeb.Api.V1.Room.MessageView do
  use ContactWeb, :view
  alias ContactWeb.Api.V1.MessageSerializer

  def render("index.json-api", %{messages: messages}) do
    #MessageSerializer
    #|> JaSerializer.format(messages)
    %{
      "data" => 
      Enum.map(messages, fn(message) ->
        %{
          "body" =>  message.body,
          "sender_id" => Integer.to_string( message.sender.id),
          "sender_name" =>  message.sender.username
        } 
      end)
    }
    #|> Poison.encode!()
  end
end
