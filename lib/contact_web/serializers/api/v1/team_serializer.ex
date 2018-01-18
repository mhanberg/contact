defmodule ContactWeb.Api.V1.TeamSerializer do
  use JaSerializer
  alias ContactWeb.Api.V1.UserSerializer

  location("/api/v1/team/:id")
  attributes([:name, :owner_id])

  has_one(
    :owner,
    serializer: UserSerializer,
    include: true
  )
end
