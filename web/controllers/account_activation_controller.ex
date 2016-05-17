defmodule Formerer.AccountActivationController do
  use Formerer.Web, :controller
  alias Formerer.{User, UserCreator}

  def edit(conn, %{ "id" => id, "email" => email }) do
    user = Repo.get_by!(User, email: email)
    changeset = User.activation_changeset(user, %{activation_token: id})

    case UserCreator.activate_account(changeset, Repo) do
      { :ok, user } ->
        conn
        |> put_flash(:info, "Account activated")
        |> redirect(to: "/")
      { :error, changeset } ->
        conn
        |> put_flash(:info, "Error activating account")
        |> redirect(to: "/")
    end
  end
end
