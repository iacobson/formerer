defmodule Formerer.AccountActivation do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]
  import Formerer.Session, only: [current_user: 1]

  def init(default), do: default

  def call(conn, _default) do
    user = current_user(conn)
    if user.activated  do
      conn
    else
      conn
      |> put_flash(:info, "Account not activated")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
