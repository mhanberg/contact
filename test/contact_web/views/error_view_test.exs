defmodule ContactWeb.ErrorViewTest do
  use ContactWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(ContactWeb.ErrorView, "404.json", []) == "Page not found"
  end

  test "render 500.json" do
    assert render(ContactWeb.ErrorView, "500.json", []) == "Internal server error"
  end

  test "render any other" do
    assert render(ContactWeb.ErrorView, "505.html", []) == "Internal server error"
  end
end
