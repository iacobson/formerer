defmodule Formerer.IntegrationNotifier do

  alias Formerer.Form
  alias Formerer.Integration.{Slack}

  def notify_integrations(form, submission) do
    form
    |> Form.enabled_integrations
    |> Enum.each(&(notify_integration(&1, submission, form)))
  end

  defp notify_integration(:slack, submission, _form) do
    Slack.notify(submission)
  end

end
