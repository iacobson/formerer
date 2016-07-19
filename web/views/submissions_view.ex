defmodule Formerer.SubmissionsView do
  use Formerer.Web, :view
  import Formerer.{ColumnFormatter, DetailFormatter}

  def column_count(form) do
    form
    |> selected_columns
    |> Enum.count
  end

  def all_fields(submission) do
    system_columns
    |> Map.keys
    |> Enum.map(&({ &1, Map.get(submission, &1)}))
    |> Map.new
    |> Map.merge(submission.fields)
  end

  def selected_columns(form) do
    Enum.concat(Map.keys(system_columns), form.columns)
  end

  def column_value(submission, key) do
    Map.get(submission, key, Map.get(submission.fields, key))
  end

  def render("submission.json", %{submission: submission}) do
    %{
      id: submission.id,
      fields: submission.fields,
      inserted_at: Ecto.DateTime.to_string(submission.inserted_at)
    }
  end
end
