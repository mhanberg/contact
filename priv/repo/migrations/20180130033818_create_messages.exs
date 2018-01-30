defmodule Contact.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :sender_id, references(:users, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps()
    end

    create index(:messages, [:sender_id])
    create index(:messages, [:room_id])
  end
end
