defmodule Formerer.UserCreator do
  import Ecto.Changeset, only: [put_change: 3]
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  def create(changeset, repo) do
    changeset
    |> put_change(:email, String.downcase(changeset.params["email"]))
    |> put_change(:password_digest, hashed_password(changeset.params["password"]))
    |> repo.insert()
  end

  def update(changeset, repo) do
    changeset
    |> put_change(:password_digest, hashed_password(changeset.params["password"]))
    |> repo.update()
  end

  defp hashed_password(password) do
    hashpwsalt(password)
  end
end
