defmodule Formerer.TestsHelpers.UserHelper do
  import Formerer.Router.Helpers
  import Formerer.UserFactory
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  def login_with_email_and_pass(conn, email, password) do
    user = create(:user, [email: email, password_digest: hashpwsalt(password)])
    conn = Plug.Conn.assign(conn, :user, user)
    {:ok, conn: conn, user: user}
  end

  def login_user(conn) do
    user = create(:user)
    conn = Plug.Conn.assign(conn, :user, user)
    {:ok, conn: conn, user: user}
  end
end
