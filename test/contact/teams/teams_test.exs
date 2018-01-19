defmodule Contact.TeamsTest do
  use Contact.DataCase
  import Contact.Factory
  alias Contact.{Teams, Teams.Team}

  describe "team" do
    test "get" do
      expected_team = insert(:team)

      assert %Team{} = team = Teams.get_team(expected_team.id)

      assert expected_team == team
    end

    test "create" do
      user = insert(:user)

      valid_team_attrs = %{
        "name" => "Bob's Team",
        "owner_id" => user.id
      }

      assert {:ok, %Team{} = team} = Teams.create_team(valid_team_attrs)

      assert team.name == valid_team_attrs["name"]
      assert team.owner == user
    end

    test "update" do
      team = insert(:team)

      assert {:ok, %Team{} = team} =
               Teams.update_team(team.id, %{"owner_id" => team.owner_id, "name" => "McDonalds"})

      assert team.name == "McDonalds"
    end

    test "delete" do
      expected_team = insert(:team)

      assert {:ok, %Team{}} = Teams.delete_team(expected_team.id)
    end
  end
end
