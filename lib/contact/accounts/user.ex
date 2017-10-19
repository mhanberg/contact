defmodule Contact.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Contact.Accounts.User

  schema "users" do
    field :email, :string
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  def signup_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password, :password_confirmation])
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 8, max: 255)
    |> validate_confirmation(:password, required: true)
    |> hash_password
  end

  @required_fields ~w(email username first_name last_name)a
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_digest, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
