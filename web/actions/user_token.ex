defmodule Formerer.UserToken do
  import Ecto.Changeset, only: [add_error: 3]
  alias Formerer.{Repo, User}

  def verify_token(changeset) do
    case changeset do
      %Ecto.Changeset{changes: %{token: token}} ->
        is_correct_token?(token, changeset)
      _->
        changeset
    end
  end

  defp is_correct_token?(token, changeset) do
    user = Repo.get_by(User, token: token)

    cond do
      user ->
        changeset = User.token_changeset(user, %{token: token})
      true ->
        add_error(changeset, :user_token, "wrong")
    end
  end
end
