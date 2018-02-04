defmodule ContactWeb.Api.V1.TokenSerializer do
  use JaSerializer

  attributes([:token])
  
  has_one(
    :user,
    include: true,
    serializer: ContactWeb.Api.V1.UserSerializer
  )

  def user(token, _c) do
    {:ok, user, _c} = ContactWeb.Guardian.resource_from_token(token.token)
    user
  end
end
