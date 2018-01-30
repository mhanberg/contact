defmodule ContactWeb.Api.V1.Room.UserController do
  use ContactWeb, :controller

  action_fallback(ContactWeb.Api.V1.FallbackController)

  alias Contact.Rooms
  alias Contact.Rooms.Member

  def create(conn, %{"room_id" => room_id, "data" => data}) do
    %{"id" => user_id} = JaSerializer.Params.to_attributes(data)

    with {:ok, _t} <- Rooms.add_member(room_id, user_id) do
      conn
      |> put_status(201)
      |> render("default.json-api")
    end
  end

  def delete(conn, %{"room_id" => room_id, "id" => user_id}) do
    with {:ok, %Member{}} <- Rooms.delete_member(room_id, user_id) do
      conn
      |> put_status(202)
      |> render("default.json-api")
    end
  end
end
