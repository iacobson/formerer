defmodule Formerer.FormSubmissionsController do
  use Formerer.Web, :controller
  alias Formerer.{Submission, SubmissionCreator}
  import Formerer.IntegrationNotifier, only: [notify_integrations: 2]

  def create(conn, params) do
    form = Repo.get_by(Formerer.Form, identifier: params["slug"])
    changeset = Submission.changeset(%Submission{ form_id: form.id }, submission_params(conn, params))

    case SubmissionCreator.create(changeset, Formerer.Repo) do
      { :ok, submission } ->
        notify_integrations(form, submission)

        conn
        |> put_status(201)
        |> json(%{ success: true, message: "Form submitted successfully" })
      { :error, changeset } ->
        conn
        |> put_status(400)
        |> json(%{ success: false, message: changeset.errors })
    end

  end

  defp submission_params(conn, params) do
    %{
      ip_address: requesting_ip(conn),
      fields: Map.drop(params, ["slug"])
    }
  end

  defp requesting_ip(conn) do
    conn.remote_ip
    |> Tuple.to_list
    |> Enum.join(".")
  end

end
