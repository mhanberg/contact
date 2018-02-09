defmodule ContactWeb.Api.V1.UserSerializer do
  use JaSerializer

  location("/api/v1/users/:id")
  attributes([:email, :username, :first_name, :last_name])

  has_many(
    :teams,
    include: true,
    serializer: ContactWeb.Api.V1.TeamSerializer
  )

  def teams(struct, _conn) do
    case struct.teams do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:teams)
        |> Contact.Repo.all()

      other ->
        other
    end
  end
end
