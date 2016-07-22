defmodule Formerer.FormColumnsController do
  use Formerer.Web, :controller
  import Formerer.Session, only: [current_user: 1]
  import Formerer.UserFormRetriever, only: [get_user_form: 2]
  import Formerer.FormColumnsUpdater
  import Ecto.Query
  alias Formerer.{Submission, Repo}

  def edit(conn, %{"forms_id" => id}) do
    case current_user(conn) |> get_user_form(id) do
      { :ok, form } ->
        submission = first_submission(form)
        conn
        |> put_layout(false)
        |> render("edit.html", form: form, submission: submission)
      { :error, error } ->
        send_resp(conn, 404, error)
    end
  end

  def update(conn, %{"columns" => columns, "forms_id" => id}) do
    case current_user(conn) |> get_user_form(id) do
      { :ok, form } ->
        case update_columns(form, columns) do
          { :ok, _ } ->
            json(conn, %{
                success: true,
                url: forms_path(conn, :show, form),
                message: "Columns updated!"
            })
          { :error, changeset} ->
            conn
            |> put_status(400)
            |> json(%{
              success: false,
              message: changeset.errors
            })
        end
      { :error, error } ->
        send_resp(conn, 404, error)
    end
  end

  defp first_submission(form) do
    Submission |> where(form_id: ^form.id) |> limit(1) |> Repo.one
  end

end
