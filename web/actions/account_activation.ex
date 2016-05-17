defmodule Formerer.AccountActivation do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]
  import Formerer.Session, only: [current_user: 1]
  import Comeonin.Bcrypt, only: [checkpw: 2]
  import Ecto.Changeset

  def init(default), do: default

  def call(conn, _default) do
    user = current_user(conn)
    if user.activated  do
      conn
    else
      conn
      |> put_flash(:info, "Account not activated")
      |> redirect(to: "/")
      |> halt()
    end
  end

  def check_activation_token(changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{activation_token: activation_token}} ->
        is_correct_token?(activation_token, changeset)
      _->
        changeset
    end
  end

  defp is_correct_token?(activation_token, changeset) do
    activation_digest = get_field(changeset, :activation_digest)
    cond do
      checkpw(activation_token, activation_digest) ->
        changeset
      true ->
        add_error(changeset, :account_activation, "error activating account")
    end
  end
end
