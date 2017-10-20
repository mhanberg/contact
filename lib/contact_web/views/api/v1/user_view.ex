defmodule ContactWeb.Api.V1.UserView do
  use ContactWeb, :view

  def render("create.json", %{user: user}) do
    %{ data:
      %{ user: user },
      status: "success"
    }
  end
end
