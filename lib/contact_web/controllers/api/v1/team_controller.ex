defmodule ContactWeb.Api.V1.TeamController do
  use ContactWeb, :controller

  action_fallback ContactWeb.Api.V1.FallbackController

  alias Contact.{Accounts, Accounts.Team}

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)

    with {:ok, %Team{} = team} <- Accounts.create_team(attrs) do
      render conn, "show.json-api", team: team
    end
  end
end
