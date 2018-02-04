defmodule ContactWeb.Api.V1.TeamSerializer do
  use JaSerializer
  alias ContactWeb.Api.V1.UserSerializer

  location("/api/v1/teams/:id")
  attributes([:name, :owner_id])

  has_one(
    :owner,
    serializer: UserSerializer
  )

  has_many(
    :members,
    include: true,
    serializer: UserSerializer
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

  def members(struct, conn) do
    case struct.members do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:members)
        |> Contact.Repo.all
      other -> other
    end
  end
end
