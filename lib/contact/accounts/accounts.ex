defmodule Contact.Accounts do
  @moduledoc """
    The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Contact.Repo
  alias Contact.Accounts.{User, Team}

  def create_user(attrs) do
    changeset = %User{} |> User.signup_changeset(attrs)

    Repo.insert(changeset)
  end

  def update_user(id, attrs) do
    user = User |> Repo.get(id)

    changeset = user |> User.changeset(attrs)

    Repo.update(changeset)
  end

  def get_user(id) do
    case User |> Repo.get(id) do
      %User{} = user ->
        user

      nil ->
        {:error, :not_found}
    end
  end

  def get_user_by(:username, username) do
    case User |> Repo.get_by(username: username) do
      %User{} = user ->
        user

      nil ->
        {:error, :not_found}
    end
  end

  def get_user_by(:email, email) do
    case User |> Repo.get_by(email: email) do
      %User{} = user ->
        user

      nil ->
        {:error, :not_found}
    end
  end

  def find(email_or_username) do
    case get_user_by(:email, email_or_username) do
      %User{} = user ->
        user

      {:error, :not_found} ->
        case get_user_by(:username, email_or_username) do
          %User{} = user ->
            user

          {:error, :not_found} ->
            {:error, :unauthorized}
        end
    end
  end

  def delete_user(id) do
    case User |> Repo.get(id) do
      %User{} = user ->
        Repo.delete(user)

      nil ->
        {:error, :not_found}
    end
  end

  def authenticate(%{user: user, password: password}) do
    case Comeonin.Bcrypt.checkpw(password, user.password_digest) do
      true ->
        ContactWeb.Guardian.encode_and_sign(user)

      _ ->
        {:error, :unauthorized}
    end
  end

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

    Repo.insert(changeset)
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
