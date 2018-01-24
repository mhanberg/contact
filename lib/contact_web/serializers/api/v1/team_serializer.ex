defmodule ContactWeb.Api.V1.TeamSerializer do
  use JaSerializer
  alias ContactWeb.Api.V1.UserSerializer

  location("/api/v1/teams/:id")
  attributes([:name])

  has_one(
    :owner,
    serializer: UserSerializer,
    include: true
  )
end
