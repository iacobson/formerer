defmodule Formerer.Repo.Migrations.AddActivationToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :activation_digest, :string
      add :activated, :boolean, default: false
      add :activated_at, :datetime
    end
  end
end
