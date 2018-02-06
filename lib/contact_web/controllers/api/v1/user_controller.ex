defmodule ContactWeb.Api.V1.UserController do
  use ContactWeb, :controller

  action_fallback(ContactWeb.Api.V1.FallbackController)

  alias Contact.{Accounts, Accounts.User}

  def create(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)

    with {:ok, %User{} = user} <- Accounts.create_user(attrs) do
      conn
      |> put_status(201)
      |> render("show.json-api", user: user)
    end
  end

  def create(conn, %{}) do
    conn
    |> put_status(400)
    |> render(ContactWeb.ErrorView, "400.json")
  end

  def update(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)
    id = data["id"]

    with {:ok, %User{} = user} <- Accounts.update_user(id, attrs) do
      render(conn, "show.json-api", user: user)
    end
  end

  def show(conn, %{"id" => "self"}) do
    ["Bearer " <> token] = conn |> get_req_header("authorization")
    {:ok, user, _c} = ContactWeb.Guardian.resource_from_token(token)

    render(conn, "show.json-api", user: user)
  end

  def show(conn, %{"id" => id}) do
    with %User{} = user <- Accounts.get_user(id) do
      render(conn, "show.json-api", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %User{}} <- Accounts.delete_user(id) do
      conn
      |> put_status(204)
      |> render("delete.json-api")
    end
  end

  def sign_in(conn, %{"data" => data}) do
    attrs = JaSerializer.Params.to_attributes(data)

    %{"login" => login, "password" => password} = attrs

    login_cred = %{login: login, password: password}

    with %User{} = user <- Accounts.find(login_cred.login) do
      with {:ok, token, _claims} <- Accounts.authenticate(%{user: user, password: login_cred.password}) do
        token = %Contact.Accounts.Token{token: token, user: user}
        render(conn, "token.json-api", token: token)
      end
    end
  end
end
