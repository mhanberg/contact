defmodule ContactWeb.Api.V1.RoomSerializer do
  use JaSerializer

  location("/api/v1/rooms/:id")
  attributes([:name])

  has_one(
    :owner,
    include: true,
    serializer: ContactWeb.Api.V1.UserSerializer
  )

  has_one(
    :team,
    include: true,
    serializer: ContactWeb.Api.V1.TeamSerializer
  )

  def owner(struct, _conn) do
    case struct.owner do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:owner)
        |> Contact.Repo.all()

      other ->
        other
    end
  end

  def team(struct, _conn) do
    case struct.team do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:team)
        |> Contact.Repo.all()

      other ->
        other
    end
  end
end
