defmodule Formerer.UserPasswordChange do
  import Comeonin.Bcrypt, only: [checkpw: 2]
  import Ecto.Changeset, only: [add_error: 3, get_field: 2]

  def check_old_password(changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{old_password: old_password}} ->
        match_old_password?(old_password, changeset)
      _ ->
        changeset
    end
  end

  defp match_old_password?(old_password, changeset) do
    password_digest = get_field(changeset, :password_digest)
    cond do
      checkpw(old_password, password_digest) ->
        changeset
      true ->
        add_error(changeset, :old_password, "is incorrect")
    end
  end

  def check_new_password(changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{password: password, confirm_password: confirm_password}} ->
        is_correct_password?(password, confirm_password, changeset)
      _ ->
        changeset
    end
  end

  defp is_correct_password?(password, confirm_password, changeset) do
    cond do
      password == confirm_password ->
        changeset
      true ->
        add_error(changeset, :password, "does not match")
    end
  end

  def check_valid_user(changeset) do
    case changeset.data.email do
      nil ->
        add_error(changeset, :user, "invalid")
      _ ->
        changeset
    end
  end
end
