defmodule Formerer.DashboardController do
  use Formerer.Web, :controller

  def index(conn, _) do
    render conn, "index.html"
  end
end
