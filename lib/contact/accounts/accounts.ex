defmodule Contact.Accounts do
  @moduledoc """
    The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Contact.Repo
  alias Contact.Accounts.User

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

  def delete_user(id) do
    case User |> Repo.get(id) do
      %User{} = user ->
        Repo.delete(user)
      nil ->
        {:error, :not_found}
    end
  end
end
