defmodule ContactWeb.Api.V1.RoomSerializer do
  use JaSerializer

  location("/api/v1/rooms/:id")
  attributes([:name])

  has_one(
    :owner,
    serializer: ContactWeb.Api.V1.UserSerializer
  )

  def owner(struct, conn) do
    case struct.owner do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:owner)
        |> Contact.Repo.all
      other -> other
    end
  end
end
