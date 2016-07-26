defmodule Formerer.UserFormRetriever do
  alias Formerer.Form
  import Ecto.Query

  def get_user_form(user, id) do
    Form
    |> where(user_id: ^user.id)
    |> Formerer.Repo.get(id)
    |> return_form
  end

  defp return_form(nil) do
    { :error, "No such form for user" }
  end

  defp return_form(form) do
    { :ok, form }
  end

end
