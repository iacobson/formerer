defmodule Formerer.FormsController do
  use Formerer.Web, :controller

  alias Formerer.{Form, FormCreator}
  import Formerer.Session, only: [current_user: 1]
  import Formerer.UserFormRetriever

  def new(conn, _) do
    changeset = Form.changeset(%Form{})
    render conn, changeset: changeset
  end

  def show(conn, %{"id" => id}) do
    case current_user(conn) |> get_user_form(id) do
      { :ok, form } ->
        form = form |> Repo.preload(:submissions)
        render conn, form: form
      { :error, error } ->
        send_resp(conn, 404, error)
    end
  end

  def create(conn, %{ "form" => form_params }) do
    changeset = Form.changeset(%Form{ identifier: "temp", user_id: current_user(conn).id }, form_params)

    case FormCreator.create(changeset, Formerer.Repo) do
      { :ok, form } ->
        conn
        |> put_flash(:info, "Form Created!")
        |> redirect(to: forms_path(conn, :show, form))
      { :error, changeset } ->
        conn
        |> put_flash(:info, "Error creating form")
        |> render("new.html", changeset: changeset)
    end
  end

  def update(conn, %{ "name" => name, "id" => id }) do
    case current_user(conn) |> get_user_form(id) do
      { :ok, form } ->
        changeset = Form.changeset(form, %{ name: name })
        case Repo.update(changeset) do
          { :ok, _ } ->
            send_resp(conn, 200, "OK")
          { :error, _ } ->
            send_resp(conn, 400, "Error updating name")
        end

      { :error, error } ->
        send_resp(conn, 404, error)
    end
  end

  def delete(conn, %{ "id" => id }) do
    case current_user(conn) |> get_user_form(id) do
      { :error, error } ->
        send_resp(conn, 404, error)
      { :ok, form } ->
        case Repo.delete(form) do
          { :ok, _ } ->
            redirect(conn, to: dashboard_path(conn, :index))
          { :error, form } ->
            send_resp(conn, 400, form)
        end
    end
  end

end
