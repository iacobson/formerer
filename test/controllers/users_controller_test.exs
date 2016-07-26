defmodule Formerer.UsersControllerTest do
  use Formerer.ConnCase
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
    conn = put(conn, users_path(conn, :update, user, user: %{old_password: "ins3cure", password: "toos3cure", confirm_password: "toos3cure"}))

    assert html_response(conn, 302)
    # there must be some refresh/reloadrefresh user
    updated_user = Repo.get(Formerer.User, user.id)

    assert checkpw("toos3cure", updated_user.password_digest)
  end

  @tag email: "test@example.com", password: "ins3cure"
  test "user cannot change the password if the old password is wrong", %{conn: conn, user: user} do
    conn = put(conn, users_path(conn, :update, user, user: %{old_password: "wrongpass", password: "toos3cure", confirm_password: "toos3cure"}))

    assert html_response(conn, 200)
    updated_user = Repo.get(Formerer.User, user.id)

    assert checkpw("ins3cure", updated_user.password_digest)
  end

  @tag email: "test@example.com", password: "ins3cure"
  test "user cannot change the password if new password confirmation is wrong", %{conn: conn, user: user} do
    conn = put(conn, users_path(conn, :update, user, user: %{old_password: "ins3cure", password: "toos3cure", confirm_password: "wrongpass"}))

    assert html_response(conn, 200)
    updated_user = Repo.get(Formerer.User, user.id)

    assert checkpw("ins3cure", updated_user.password_digest)
  end
end
