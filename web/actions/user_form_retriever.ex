defmodule Formerer.UserFormRetriever do
  alias Formerer.Form
  import Ecto.Query

  def get_user_form(user, id) do
    Form
    |> where(user_id: ^user.id)
    |> Formerer.Repo.get(id)
  end

end
