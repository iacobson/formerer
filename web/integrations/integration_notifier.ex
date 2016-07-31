defmodule Formerer.IntegrationNotifier do

  alias Formerer.Integration.{Slack}

  def notify_integrations(form, submission) do
    form.integrations
    |> Enum.each(&(notify_integration(&1, form, submission)))
  end

  defp notify_integration(:slack, form, submission) do
    Slack.notify(form, submission)
  end

end
