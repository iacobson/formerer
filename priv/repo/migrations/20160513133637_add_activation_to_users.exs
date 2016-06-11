defmodule Formerer.Repo.Migrations.AddActivationToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :token, :string
      add :activated, :boolean, default: false, null: false
      add :activated_at, :datetime
    end

    create index(:users, [:token])
  end
end
