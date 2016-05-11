defmodule Formerer.UsersControllerTest do
  use Formerer.ConnCase
  import Formerer.UserFactory
  import Comeonin.Bcrypt, only: [checkpw: 2]

  setup %{conn: conn} = config do
    if %{email: email, password: password} = config do
      login_with_email_and_pass(conn, email, password)
    else
      :ok
    end
  end

  @tag email: "test@example.com", password: "ins3cure"
  test "user can change password providing correct info", %{conn: conn, user: user} do
    response = put(conn, users_path(conn, :update, user, user: %{old_password: "ins3cure", password: "toos3cure", confirm_password: "toos3cure"}))

    assert html_response(response, 302)
    # there must be some refresh/reloadrefresh user
    updated_user = Repo.get(Formerer.User, user.id)

    assert checkpw("toos3cure", updated_user.password_digest)
  end

end
