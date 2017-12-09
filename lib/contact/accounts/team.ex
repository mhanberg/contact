defmodule Contact.Accounts.Team do
  use Ecto.Schema
  import Ecto.Changeset
  alias Contact.Accounts.Team

  @derive {Poison.Encoder, only: [:name, :owner]}
  schema "teams" do
    field :name, :string
    belongs_to :owner, Contact.Accounts.User

    timestamps()
  end

  def changeset(%Team{} = team, attrs) do
    team
      |> cast(attrs, [:name])
      |> put_assoc(:owner, attrs[:owner])
      |> validate_required([:name, :owner])
  end
end
