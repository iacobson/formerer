defmodule Formerer.Integration.Slack do

  def notify(form, submission) do
    HTTPotion.post(url, [body: payload(form, submission), stream_to: self])
  end

  defp payload(form, submission) do
    Poison.encode!(%{
      text: payload_text(form, submission)
    })
  end

  defp payload_text(form, submission) do
    start = "New submission for Form - " <> form.name

    fields = "Email: fxn@fxndev.com\nMessage: Testerererer\n"

    "#{start}\n\n```#{fields}```"
  end

  defp url do
    base_url <> "TEST_TOKEN"
  end

  defp base_url do
    "https://hooks.slack.com/services/"
  end

end
