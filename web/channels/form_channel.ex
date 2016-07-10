defmodule Formerer.FormChannel do
  use Phoenix.Channel
  use Formerer.Web, :channel
  import Formerer.UserFormRetriever
  alias Formerer.ColumnFormatter
  alias Formerer.SubmissionsView

  def join("forms:" <> form_id, _params, socket) do

    form_id = String.to_integer(form_id)
    user = Repo.get(Formerer.User, socket.assigns.user_id)
    form = user |> get_user_form(form_id) |> Repo.preload(:submissions)
    submissions = form.submissions

    selected_columns = form.columns
    system_columns = ColumnFormatter.system_columns
    column_count = Enum.count(selected_columns) + Enum.count(system_columns) + 1
    submissions_json = Phoenix.View.render_many(submissions, SubmissionsView, "submission.json", as: :submission)

    resp = %{submissions: submissions_json,
      selected_columns: selected_columns,
      system_columns: system_columns,
      column_count: column_count}

    {:ok, resp, assign(socket, :form_id, form_id) }
  end

end
