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
end
