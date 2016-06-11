defmodule Formerer.FormsControllerTest do
  use Formerer.ConnCase
  import Formerer.UserFactory

  setup %{conn: conn} = config do
    if %{activated: activated} = config do
      user = create(:user, [activated: activated])
      login_custom_user(conn, user)
    else
      :ok
    end
  end

  @tag activated: false
  test "non activated user cannot create forms", %{conn: conn, user: user} do
    conn = get(conn, forms_path(conn, :new))

    assert html_response(conn, 302)
    assert conn.halted
  end

  @tag activated: true
  test "activated user can create forms", %{conn: conn, user: user} do
    conn = get(conn, forms_path(conn, :new))

    assert html_response(conn, 200)
  end


  # add some more test for user not being able to access other user forms

end
