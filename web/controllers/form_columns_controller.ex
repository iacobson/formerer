defmodule Formerer.FormColumnsController do
  use Formerer.Web, :controller
  import Formerer.Session, only: [current_user: 1]
  import Formerer.UserFormRetriever, only: [get_user_form: 2]
  import Formerer.FormColumnsUpdater
  import Ecto.Query
  alias Formerer.{Submission, Repo}

  def edit(conn, %{"forms_id" => id}) do
    form = get_user_form(current_user(conn), id)
    submission = first_submission(form)

    conn
    |> put_layout(false)
    |> render("edit.html", form: form, submission: submission)
  end

  def update(conn, %{"columns" => columns, "forms_id" => id}) do
    form = get_user_form(current_user(conn), id)

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

  end

  defp first_submission(form) do
    Submission |> where(form_id: ^form.id) |> limit(1) |> Repo.one
  end

end
