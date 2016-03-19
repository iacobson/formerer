defmodule Formerer.IntegrationNotifier do

  alias Formerer.Form
  alias Formerer.Integration.{Slack}

  def notify_integrations(form, submission) do
    form
    |> Form.enabled_integrations
    |> Enum.each(&(notify_integration(&1, form, submission)))
  end

  defp notify_integration(:slack, form, submission) do
    Slack.notify(form, submission)
  end

end
