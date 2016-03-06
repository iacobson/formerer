Application.ensure_all_started(:hound)
Application.ensure_all_started(:ex_machina)

ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Formerer.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Formerer.Repo --quiet)

Ecto.Adapters.SQL.begin_test_transaction(Formerer.Repo)
