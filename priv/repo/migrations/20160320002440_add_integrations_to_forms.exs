defmodule Formerer.Repo.Migrations.AddIntegrationsToForms do
  use Ecto.Migration

  def change do
    alter table(:forms) do
      add :integrations, {:array, :string}, null: false, default: []
    end
  end
end
