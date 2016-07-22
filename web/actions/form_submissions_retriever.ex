defmodule Formerer.FormSubmissionsRetriever do
  import Ecto.Query
  alias Formerer.Submission
  alias Formerer.Repo

  def get_form_submissions(form, last_seen_id) do
    last_seen = last_seen_submission_date(last_seen_id)
    Submission
    |> where(form_id: ^form.id)
    |> where([submission], submission.inserted_at > ^last_seen)
    |> order_by([s], [desc: s.inserted_at])
    |> Repo.all
  end

  defp last_seen_submission_date(nil) do
    submission = Submission |> first |> Repo.one
    submission.inserted_at
  end

  defp last_seen_submission_date(last_seen_id) do
    Repo.get(Submission, last_seen_id).inserted_at
  end
end
