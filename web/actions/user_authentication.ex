defmodule Formerer.UserAuthentication do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]
  import Formerer.Session, only: [current_user: 1]

  def init(default), do: default

  def call(conn, _default) do
    case current_user(conn) do
      nil ->
        conn
        |> put_flash(:info, "Not Authorized")
        |> redirect(to: "/")
        |> halt()
      user ->
        assign(conn, :user, user)
    end
  end

end
