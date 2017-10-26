defmodule ContactWeb.Api.V1.UserView do
  use ContactWeb, :view
  alias ContactWeb.Api.V1.UserSerializer

  def render("show.json-api", %{user: user}) do
    UserSerializer
    |> JaSerializer.format(user)
  end

  def render("delete.json-api", _assigns) do
    ""
  end
end
