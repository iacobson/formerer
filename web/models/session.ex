defmodule Formerer.Session do
  import Comeonin.Bcrypt, only: [checkpw: 2]
  import Plug.Conn
  alias Formerer.User
  alias Formerer.Repo

  def login(params) do
    user = Repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  def current_user(conn) do
    case conn.assigns[:user] do
      nil ->
        id = get_session(conn, :current_user)
        if id do
          user = Repo.get(User, id)
          token = Phoenix.Token.sign(conn, "user socket", user.id)
          conn
          |> assign(:user, user)
          |> assign(:user_token, token)
          user
        end
      user ->
        user
    end
  end

  def logged_in?(conn), do: !!current_user(conn)

  defp authenticate(user, password) do
    case user do
      nil -> false
      _ -> checkpw(password, user.password_digest)
    end
  end
end
