defmodule ContactWeb.ErrorView do
  use ContactWeb, :view

  def render("404.json", _assigns) do
    "Page not found"
  end

  def render("500.json", _assigns) do
    "Internal server error"
  end

  def render("409.json", %{changeset: changeset}) do
    %{
      errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    }
  end

  def render("400.json", _assigns) do
    %{
      errors: [
        %{ status: 400, detail: "Bad Request" }
      ]
    }
  end

  def render("401.json", _assigns) do
    %{
      errors: [
        %{ status: 401, detail: "Unauthorized" }
      ]
    }
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
