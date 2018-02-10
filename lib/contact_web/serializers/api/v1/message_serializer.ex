defmodule ContactWeb.Api.V1.MessageSerializer do
  use JaSerializer

  attributes([:body])

  has_one(
    :sender,
    include: true,
    serializer: ContactWeb.Api.V1.UserSerializer
  )

  has_one(
    :room,
    include: true,
    serializer: ContactWeb.Api.V1.RoomSerializer
  )

  def sender(struct, _conn) do
    case struct.sender do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:sender)
        |> Contact.Repo.all()

      other ->
        other
    end
  end

  def room(struct, _conn) do
    case struct.room do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:room)
        |> Contact.Repo.all()

      other ->
        other
    end
  end
end
