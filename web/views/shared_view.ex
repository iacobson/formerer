import Formerer.Router.Helpers

defmodule Formerer.SharedView do
  import Ecto.Query
  use Formerer.Web, :view
  alias Formerer.Form
  alias Formerer.Repo

  def user_forms(conn) do
    user_id = current_user(conn).id

    Form
    |> where(user_id: ^user_id)
    |> Repo.all
  end

end
