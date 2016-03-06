defmodule Formerer.Repo.Migrations.AddColumnsToForms do
  use Ecto.Migration

  def change do
    alter table(:forms) do
      add :columns, {:array, :string}, null: false, default: []
    end
  end
end
