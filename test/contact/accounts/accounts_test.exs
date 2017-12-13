defmodule Contact.AccountsTest do
  use Contact.DataCase
  import Contact.Factory
  alias Contact.Accounts
  alias Contact.Accounts.{User, Team}

  @valid_user_attrs %{
    email: "legoman25@aol.com",
    username: "legoman25",
    first_name: "Mitch",
    last_name: "Hanberg",
    password: "password",
    password_confirmation: "password"
  }
  describe "create_user" do
    test "create_user succeeds with valid data" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_user_attrs)

      assert user.email == @valid_user_attrs.email
      assert user.username == @valid_user_attrs.username
      assert user.first_name == @valid_user_attrs.first_name
      assert user.last_name == @valid_user_attrs.last_name
    end
  end

  describe "update_user" do
    test "update_user succeeds with valid data" do
      user = insert(:user)

      assert {:ok, %User{} = user} = Accounts.update_user(user.id, %{ first_name: "billy" })

      assert user.first_name == "billy"
    end
  end

  describe "get_user" do
    test "get users succeeds with valid id" do
      expected_user = insert(:user)

      assert %User{} = user = Accounts.get_user(expected_user.id)

      assert expected_user == user
    end
  end

  describe "delete_user" do
    test "delete user succeeds with valid id" do
      expected_user = insert(:user)

      assert {:ok, %User{}} = Accounts.delete_user(expected_user.id)
    end

    test "returns not found when user not found" do
      assert {:error, :not_found} = Accounts.delete_user(34523452354)
    end
  end

  describe "get_user_by" do
    test "returns user by username" do
      expected_user = insert(:user, username: "bob")

      assert %User{} = result_user = Accounts.get_user_by(:username, expected_user.username)
      assert result_user == expected_user
    end

    test "returns error when no user found by username" do
      insert(:user, username: "bob")

      assert {:error, :not_found} = Accounts.get_user_by(:username, "notfound123")
    end

    test "returns user by email" do
      expected_user = insert(:user, email: "bob@bob.co")

      assert %User{} = result_user = Accounts.get_user_by(:email, "bob@bob.co")
      assert result_user == expected_user
    end
  end

  describe "find" do
    test "returns user by username" do
      expected_user = insert(:user, username: "billy")
      insert(:user, username: "notbilly")

      assert %User{} = result_user = Accounts.find("billy")
      assert result_user == expected_user
    end

    test "returns user by email" do
      expected_user = insert(:user, email: "billy@bill.co")
      insert(:user, username: "notbilly@bill.co")

      assert %User{} = result_user = Accounts.find("billy@bill.co")
      assert result_user == expected_user
    end

    test "fail when neither are found" do
      insert(:user)

      assert {:error, :unauthorized} = Accounts.find("wontfindthisusername")
      assert {:error, :unauthorized} = Accounts.find("wontfindthisemail@email.com")
    end
  end

  describe "authenticate" do
    test "should validate a password against its users stored hash" do
      user = insert(:user, password_digest: Comeonin.Bcrypt.hashpwsalt("password"))

      assert {:ok, _token, _claims} = Accounts.authenticate(%{user: user, password: "password"})
    end

    test "should return mismatch if password doesn't match stored hash" do
      user = insert(:user, password_digest: Comeonin.Bcrypt.hashpwsalt("password"))

      assert {:error, :unauthorized} = Accounts.authenticate(%{user: user, password: "notthepassword"})
    end
  end

  describe "team" do
    test "get" do
      expected_team = insert(:team)

      assert %Team{} = team = Accounts.get_team(expected_team.id)

      assert expected_team == team
    end

    test "create" do
      user = insert(:user)
      valid_team_attrs = %{
        "name" => "Bob's Team",
        "owner_id" => user.id
      }
      assert {:ok, %Team{} = team} = Accounts.create_team(valid_team_attrs)

      assert team.name == valid_team_attrs["name"]
      assert team.owner == user
    end

    test "update" do
      team = insert(:team)

      assert {:ok, %Team{} = team} = Accounts.update_team(team.id, %{"owner_id" => team.owner_id, "name" => "McDonalds" })

      assert team.name == "McDonalds"
    end

    test "delete" do
      expected_team = insert(:team)

      assert {:ok, %Team{}} = Accounts.delete_team(expected_team.id)
    end
  end
end
