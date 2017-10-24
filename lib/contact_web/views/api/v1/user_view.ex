defmodule ContactWeb.Api.V1.UserView do
  use ContactWeb, :view

  def render("create.json", %{user: user}) do
    %{
      data: %{
        type: "users",
        id: Map.fetch!(user, :id),
        attributes: attributes(user)
      }
    }
  end

  defp attributes(user) do
    user |> Map.take([:email, :username, :first_name, :last_name])
  end
end
