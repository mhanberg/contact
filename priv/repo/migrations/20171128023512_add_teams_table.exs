defmodule Contact.Repo.Migrations.AddTeamsTable do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string, null: false, size: 25
      add :owner_id, references(:users)

      timestamps()
    end
  end
end
