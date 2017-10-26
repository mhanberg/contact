defmodule Contact.AccountsTest do
  use Contact.DataCase
  import Contact.Factory
  alias Contact.Accounts
  alias Contact.Accounts.User

  @valid_attrs %{
    email: "legoman25@aol.com",
    username: "legoman25",
    first_name: "Mitch",
    last_name: "Hanberg",
    password: "password",
    password_confirmation: "password"
  }

  test "create_user succeeds with valid data" do
    assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)

    assert user.email == @valid_attrs.email
    assert user.username == @valid_attrs.username
    assert user.first_name == @valid_attrs.first_name
    assert user.last_name == @valid_attrs.last_name
  end

  test "update_user succeeds with valid data" do
    user = insert(:user)

    assert {:ok, %User{} = user} = Accounts.update_user(user.id, %{ first_name: "billy" })

    assert user.first_name == "billy"
  end

  test "get users succeeds with valid id" do
    expected_user = insert(:user)

    assert %User{} = user = Accounts.get_user(expected_user.id)

    assert expected_user == user
  end
end
