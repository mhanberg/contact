defmodule Contact.Repo.Migrations.CreateRoomsUsers do
  use Ecto.Migration

  def change do
    create table(:rooms_users) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :room_id, references(:rooms, on_delete: :delete_all)

      timestamps()
    end

    create index(:rooms_users, [:user_id])
    create index(:rooms_users, [:room_id])
  end
end
