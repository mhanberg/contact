defmodule Contact.Accounts.UserTest do
  use Contact.DataCase

  alias Contact.Accounts.User

  @valid_attrs %{
    email: "legoman25@aol.com",
    username: "legoman25",
    first_name: "Mitch",
    last_name: "Hanberg",
    password: "password",
    password_confirmation: "password"
  }

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid email with no @" do
    changeset = User.changeset(%User{}, Map.put(@valid_attrs, :email, "noatsign.com"))
    refute changeset.valid?
  end

  test "changeset with invalid email with no tld" do
    changeset = User.changeset(%User{}, Map.put(@valid_attrs, :email, "legoman@blank"))
    refute changeset.valid?
  end

  test "signup_changeset with valid attributes" do
    changeset = User.signup_changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "signup_changeset with no password" do
    changeset = User.signup_changeset(%User{}, Map.delete(@valid_attrs, :password))
    refute changeset.valid?
  end

  test "signup_changeset with no password confirmation" do
    changeset = User.signup_changeset(%User{}, Map.delete(@valid_attrs, :password_confirmation))
    refute changeset.valid?
  end

  test "signup_changeset with incorrect password length" do
    changeset = User.signup_changeset(%User{}, Map.put(@valid_attrs, :password, "pass"))
    refute changeset.valid?

    changeset = User.signup_changeset(%User{}, %{@valid_attrs | password: String.duplicate("p", 256)})
    refute changeset.valid?
  end

  test "signup_changeset with mismatching password confirmation" do
    changeset = User.signup_changeset(%User{}, Map.put(@valid_attrs, :password_confirmation, "nomatchforyou"))
    refute changeset.valid?
  end
end
