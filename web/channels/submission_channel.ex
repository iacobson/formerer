defmodule Formerer.SubmissionChannel do
  use Phoenix.Channel

  def join("submissions:" <> form_id, _message, socket) do
    {:ok, form_id}
  end

end
