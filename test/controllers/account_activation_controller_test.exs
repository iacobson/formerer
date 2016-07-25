defmodule Formerer.AccountActivationControllerTest do
  use Formerer.ConnCase
  import Formerer.UserFactory

  test "user can activate account with correct token" do
    user = insert(:user, activated: false, token: "activationtoken")
    conn = get(build_conn, account_activation_path(build_conn, :edit, "activationtoken"))

    assert html_response(conn, 302)
    updated_user = Repo.get(Formerer.User, user.id)

    assert updated_user.activated == true
    assert updated_user.token == nil
  end

end
