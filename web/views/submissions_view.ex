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
    |> Keyword.keys
    |> Enum.map(&({ &1, Map.get(submission, &1)}))
    |> Map.new
    |> Map.merge(submission.fields)
  end

  def selected_columns(form) do
    Enum.concat(Keyword.keys(system_columns), form.columns)
  end

  def column_value(submission, key) do
    Map.get(submission, key, Map.get(submission.fields, key))
  end

end
