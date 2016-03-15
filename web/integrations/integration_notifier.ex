defmodule Formerer.IntegrationNotifier do

  alias Formerer.Form
  alias Formerer.Integration.{Slack}

  def notify_integrations(form, submission) do
    form
    |> Form.enabled_integrations
    |> Enum.each(&(integration(&1)).(submission))
  end

  defp integration(key) do
    Keyword.fetch!([
      slack: &Slack.notify/1
    ], key)
  end

end
