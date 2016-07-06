defmodule Formerer.FormChannel do
  use Phoenix.Channel

  def join("forms:" <> form_id, _params, socket) do
    {:ok, socket}
  end

end
