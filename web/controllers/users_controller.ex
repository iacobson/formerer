defmodule Formerer.UsersController do
  use Formerer.Web, :controller
  alias Formerer.{User, UserCreator}
  import Formerer.Session, only: [current_user: 1]

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

  def edit(conn, _) do
    user = current_user(conn)
    changeset = User.password_change_changeset(user)
    render(conn, "edit.html", changeset: changeset, user: user)
  end

  def update(conn, %{ "user" => user_params }) do
    user = current_user(conn)
    changeset = User.password_change_changeset(user, user_params)

    case UserCreator.update(changeset, Repo) do
      { :ok, user } ->
        conn
        |> put_flash(:info, "Password changed")
        |> redirect(to: "/")
      { :error, changeset } ->
        conn
        |> put_flash(:info, "Error updating password")
        |> render("edit.html", changeset: changeset, user: user)
    end
  end
end
