defmodule Formerer.PasswordResetController do
  use Formerer.Web, :controller
  alias Formerer.{User, UserCreator, Mailer, Integration.Email}

  def new(conn, _) do
    changeset = User.email_changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{ "user" => user_params }) do
    user = Repo.get_by(User, email: String.downcase(user_params["email"])) || %User{}
    # there must be some cleaner and faster way to do this
    changeset = User.email_changeset(user, user_params)

    case UserCreator.add_token(changeset, Repo) do
      { :ok, user } ->
        Email.password_reset(conn, user)
        |> Mailer.deliver()

        conn
        |> put_flash(:info, "Password reset request sent. Please check your email")
        |> redirect(to: "/")
      { :error, changeset } ->
        conn
        |> put_flash(:info, "Incorrect email address")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{ "id" => id }) do
    changeset = User.token_changeset(%User{}, %{token: id})
    if changeset.valid? do
      render(conn, "edit.html", changeset: changeset, token: id)
    else
      conn
      |> put_flash(:info, "Error reseting password. Please try again.")
      |> redirect(to: password_reset_path(conn, :new))
    end
  end

  def update(conn, %{ "user" => user_params, "id" =>id }) do
    changeset = User.password_reset_changeset(%User{}, user_params)
    user = changeset.data

    case UserCreator.update(changeset, Repo) do
      { :ok, user } ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "Password reset successfuly")
        |> redirect(to: "/")
      { :error, changeset } ->
        conn
        |> put_flash(:info, "Password reset error")
        |> render("edit.html", changeset: changeset, token: id)
    end
  end
end
