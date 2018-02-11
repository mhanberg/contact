defmodule ContactWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:" <> _room_id, _auth_message, socket) do
    {:ok, socket}
  end

  def handle_in("new:msg" = event, msg, socket) do
    Contact.Messages.create_message(msg)
    
    broadcast!(socket, event, msg)
    {:noreply, socket}
  end
end
