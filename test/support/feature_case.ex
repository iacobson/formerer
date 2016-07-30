defmodule Formerer.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Hound.Helpers

      import Formerer.Router.Helpers
      alias Formerer.Repo

      @endpoint Formerer.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Formerer.Repo)

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Formerer.Repo, self())
    Hound.start_session(metadata: metadata)

    :ok
  end

end
