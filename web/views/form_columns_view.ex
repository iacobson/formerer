defmodule Formerer.FormColumnsView do
  use Formerer.Web, :view
  import Formerer.ColumnFormatter

  def submission_fields(submission) do
    Map.keys(submission.fields)
  end

  def field_key_as_atom(key) do
    String.to_atom(key)
  end

end
