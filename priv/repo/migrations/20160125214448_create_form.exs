defmodule Formerer.Repo.Migrations.CreateForm do
  use Ecto.Migration

  def change do
    create table(:forms) do
      add :name, :string, null: false
      add :identifier, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps
    end
    create index(:forms, [:user_id])

  end
end
