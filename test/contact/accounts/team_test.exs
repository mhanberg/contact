defmodule Contact.Accounts.TeamTest do
  use Contact.DataCase
  import Contact.Factory
  alias Contact.Accounts.Team

  test "changeset with valid attributes" do
    changeset = Team.changeset(%Team{}, %{name: "SEP", owner: insert(:user)})
    assert changeset.valid?
  end

  test "changeset with invalid attributes fails" do
    changeset = Team.changeset(%Team{}, %{})
    refute changeset.valid?
  end
end
