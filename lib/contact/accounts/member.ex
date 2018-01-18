defmodule Member do
  use Ecto.Schema
  alias Contact.Accounts.{Team, User}

  schema "users_teams" do
    belongs_to(:user, User)
    belongs_to(:team, Team)

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:user_id, :team_id])
    |> Ecto.Changeset.validate_required([:user_id, :team_id])
  end
end
