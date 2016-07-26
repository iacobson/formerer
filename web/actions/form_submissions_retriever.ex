defmodule Formerer.FormSubmissionsRetriever do
  import Ecto.Query, only: [where: 2, where: 3, order_by: 3, first: 1, select: 3]
  alias Formerer.{Submission, Repo}

  def get_form_submissions(form, last_seen_id) do
    last_seen = last_seen_submission_date(last_seen_id)
    Submission
    |> where(form_id: ^form.id)
    |> where([s], s.inserted_at > ^last_seen)
    |> order_by([s], [desc: s.inserted_at])
    |> Repo.all
  end

  defp last_seen_submission_date(nil) do
    Submission |> select([s], s.inserted_at) |> first |> Repo.one
  end

  defp last_seen_submission_date(last_seen_id) do
    Submission |> select([s], s.inserted_at) |> Repo.get(last_seen_id)
  end
end
