defmodule Formerer.UserCreator do
  import Ecto.Changeset, only: [put_change: 3]
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]
  import Formerer.TokenGenerator, only: [new_token: 1]

  def create(changeset, repo) do
    token = new_token(64)

    changeset
    |> put_change(:email, String.downcase(changeset.params["email"]))
    |> put_change(:password_digest, hashed_string(changeset.params["password"]))
    |> put_change(:token, token)
    |> repo.insert()
  end

  def update(changeset, repo) do
    changeset
    |> put_change(:password_digest, hashed_string(changeset.params["password"]))
    |> repo.update()
  end

  def activate_account(changeset, repo) do
    changeset
    |> put_change(:activated, true)
    |> put_change(:activated_at, Timex.DateTime.now)
    |> repo.update()
  end

  defp hashed_string(password) do
    hashpwsalt(password)
  end

end
