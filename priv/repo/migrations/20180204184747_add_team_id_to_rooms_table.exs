defmodule Contact.Repo.Migrations.AddTeamIdToRoomsTable do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :team_id, references(:teams, on_delete: :delete_all), null: false
    end
  end
end
