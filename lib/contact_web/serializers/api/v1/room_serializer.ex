defmodule ContactWeb.Api.V1.RoomSerializer do
  use JaSerializer

  location("/api/v1/rooms/:id")
  attributes([:name])

  has_one(
    :owner,
    serializer: ContactWeb.Api.V1.UserSerializer
  )
end
