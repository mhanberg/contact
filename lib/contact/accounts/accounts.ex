defmodule Contact.Accounts do
  import Ecto.Query, warn: false
  alias Contact.Repo
  alias Contact.Accounts.User

  def create_user(attrs) do
    changeset = %User{} |> User.signup_changeset(attrs)
    team = Repo.get(Contact.Teams.Team, 1)
    room = Repo.get(Contact.Rooms.Room, 10)
    case insert_result= Repo.insert(changeset) do
      {:ok, user} ->
        if team, do: Contact.Teams.add_member(team.id, user.id)
        if room, do: Contact.Rooms.add_member(room.id, user.id) 

        {:ok, user}
      _ -> 
        insert_result
    end

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
end
