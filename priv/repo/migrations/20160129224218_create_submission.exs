defmodule Formerer.Repo.Migrations.CreateSubmission do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :fields, :map, null: false
      add :ip_address, :string, null: false
      add :form_id, references(:forms, on_delete: :nothing), null: false

      timestamps
    end
    create index(:submissions, [:form_id])

  end
end
