defmodule Formerer.UsersController do
  use Formerer.Web, :controller
  alias Formerer.{User, UserCreator}

  def new(conn, _) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{ "user" => user_params }) do
    changeset = User.changeset(%User{}, user_params)

    case UserCreator.create(changeset, Formerer.Repo) do
      { :ok, user } ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "Account created")
        |> redirect(to: "/")
      { :error, changeset } ->
        conn
        |> put_flash(:info, "Error creating account")
        |> render("new.html", changeset: changeset)
    end
  end

end
