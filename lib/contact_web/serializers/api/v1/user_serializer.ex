defmodule ContactWeb.Api.V1.UserSerializer do
  use JaSerializer

  location("/api/v1/users/:id")
  attributes([:email, :username, :first_name, :last_name])
end
