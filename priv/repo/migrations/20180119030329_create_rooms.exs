defmodule Contact.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:rooms, [:owner_id])
  end
end
