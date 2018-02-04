defmodule Contact.Teams do
  import Ecto.Query, warn: false
  alias Contact.Repo
  alias Contact.Accounts.User
  alias Contact.Teams.Team
  alias Contact.Teams.Member

  def get_team(id) do
    case Team |> Repo.get(id) |> Repo.preload(:owner) |> Repo.preload(:members) do
      %Team{} = team ->
        team

      nil ->
        {:error, :not_found}
    end
  end

  def create_team(attrs) do
    changeset = %Team{} |> Team.changeset(attrs)

    {:ok, team} = Repo.insert(changeset)
    add_member(team.id, team.owner_id)

    {:ok, team}
  end

  def update_team(id, attrs) do
    team = Team |> Repo.get(id) |> Repo.preload(:owner)

    changeset = team |> Team.changeset(attrs)

    Repo.update(changeset)
  end

  def delete_team(id) do
    case Team |> Repo.get(id) do
      %Team{} = team ->
        Repo.delete(team)

      nil ->
        {:error, :not_found}
    end
  end

  def add_member(team_id, user_id) do
    team = Team |> Repo.get!(team_id) |> Repo.preload(:members)
    user = User |> Repo.get!(user_id)

    team
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:members, [user])
    |> Repo.update()
  end

  def delete_member(team_id, user_id) do
    case Member |> Repo.get_by(team_id: team_id, user_id: user_id) do
      %Member{} = member ->
        Repo.delete(member)

      nil ->
        {:error, :not_found}
    end
  end
end
