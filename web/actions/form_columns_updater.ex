defmodule Formerer.FormColumnsUpdater do
  import Ecto.Changeset, only: [change: 1, put_change: 3]
  alias Formerer.Repo

  def update_columns(form, columns) do
    form
    |> change
    |> put_change(:columns, selected_columns(columns))
    |> Repo.update
  end

  defp selected_columns(columns) do
    Enum.filter_map(columns, &(elem(&1, 1) == "true"), &(elem(&1, 0)))
  end

end
