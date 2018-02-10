defmodule ContactWeb.Api.V1.Room.MessageController do
  use ContactWeb, :controller

  action_fallback(ContactWeb.Api.V1.FallbackController)

  alias Contact.Messages 

  def index(conn, %{"room_id" => room_id}) do
    with messages <- Messages.get_messages_for_room(room_id) do
      render(conn, "index.json-api", messages: messages)
    end
  end
end
