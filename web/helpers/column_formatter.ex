defmodule Formerer.ColumnFormatter do
  import String, only: [replace: 3, capitalize: 1]

  def system_columns do
    %{inserted_at: "Received"}
  end

  def pretty_column_name(key) when is_binary(key) do
    key
    |> String.to_atom
    |> pretty_column_name
  end

  def pretty_column_name(key) do
    Map.get(system_columns, key, format_column_name(key))
  end

  defp format_column_name(key) when is_atom(key) do
    key
    |> Atom.to_string
    |> format_column_name
  end

  defp format_column_name(key) do
    key
    |> replace(~r/-|_/, " ")
    |> capitalize
  end

end
