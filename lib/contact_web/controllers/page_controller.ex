defmodule ContactWeb.PageController do
  use ContactWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
