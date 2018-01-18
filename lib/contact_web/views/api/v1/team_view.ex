defmodule ContactWeb.Api.V1.TeamView do
  use ContactWeb, :view
  alias ContactWeb.Api.V1.TeamSerializer

  def render("show.json-api", %{team: team}) do
    TeamSerializer
    |> JaSerializer.format(team)
  end

  def render("delete.json-api", _assigns) do
    ""
  end
end
