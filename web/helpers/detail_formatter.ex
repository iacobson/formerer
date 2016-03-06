defmodule Formerer.DetailFormatter do
  import Phoenix.HTML.Format, only: [text_to_html: 1]

  def detail_value(value) when is_binary(value) do
    value |> text_to_html
  end

  def detail_value(value) do
    Ecto.DateTime.to_string(value)
  end

end
