defmodule Formerer.FormCreator do
  import Ecto.Changeset, only: [put_change: 3]
  import UUID, only: [uuid4: 1]

  def create(changeset, repo) do
    changeset
    |> put_change(:identifier, uuid4(:hex))
    |> repo.insert()
  end

end
