defmodule Formerer.FormSettingsController do
  use Formerer.Web, :controller
  import Formerer.Session, only: [current_user: 1]
  import Formerer.UserFormRetriever

  def edit(conn, %{"form_id" => id}) do
    case current_user(conn) |> get_user_form(id) do
      { :error, error } ->
        send_resp(conn, 404, error)
      { :ok, form } ->
        render conn, form: form
    end
  end
end
