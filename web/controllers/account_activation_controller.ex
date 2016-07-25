defmodule Formerer.AccountActivationController do
  use Formerer.Web, :controller
  alias Formerer.{User, UserCreator}

  def edit(conn, %{ "id" => id }) do
    changeset = User.token_changeset(%User{}, %{token: id})

    case UserCreator.activate_account(changeset, Repo) do
      { :ok, _user } ->
        conn
        |> put_flash(:info, "Account activated")
        |> redirect(to: "/")
      { :error, _changeset } ->
        conn
        |> put_flash(:info, "Error activating account")
        |> redirect(to: "/")
    end
  end
end
