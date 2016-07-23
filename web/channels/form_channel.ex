defmodule Formerer.FormChannel do
  use Phoenix.Channel
  use Formerer.Web, :channel
  import Formerer.UserFormRetriever, only: [get_user_form: 2]
  import Formerer.FormSubmissionsRetriever, only: [get_form_submissions: 2]
  alias Formerer.{ColumnFormatter, SubmissionsView}

  def join("forms:" <> form_id, params, socket) do
    last_seen_id = params["last_seen_id"]
    form_id = String.to_integer(form_id)
    user = Repo.get(Formerer.User, socket.assigns.user_id)

    case get_user_form(user, form_id) do
      {:ok, form} ->
        submissions = get_form_submissions(form, last_seen_id)
        resp = submissions_payload(submissions, form)
        {:ok, resp, assign(socket, :form_id, form_id) }

      {:error, error} ->
        {:error, error}
    end
  end

  def broadcast_new_submission(submission, form) do
    payload = submissions_payload([submission], form)
    Formerer.Endpoint.broadcast("forms:#{form.id}", "new_submission", payload)
  end


  defp submissions_payload(submissions, form) do
    selected_columns = form.columns
    system_columns = ColumnFormatter.system_columns
    column_count = Enum.count(selected_columns) + Enum.count(system_columns) + 1
    submissions_json = Phoenix.View.render_many(submissions, SubmissionsView, "submission.json", as: :submission)

    %{
      submissions: submissions_json,
      selected_columns: selected_columns,
      system_columns: system_columns,
      column_count: column_count
    }
  end
end
