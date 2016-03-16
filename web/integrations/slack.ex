defmodule Formerer.Integration.Slack do

  def notify(_submission) do
    HTTPotion.post(url, [body: payload, stream_to: self])
  end

  defp payload do
    Poison.encode!(%{
      text: "Test \n Messaaaaage!"
    })
  end

  defp url do
    base_url <> "ENDPOINT/CODE/THANGS"
  end

  defp base_url do
    "https://hooks.slack.com/services/"
  end

end
