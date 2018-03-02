defmodule YandexTranslator.Translate do
  @moduledoc """
  Module for text translation
  """

  def run(args) do
    key = args[:key] ? args[:key] : Application.get_env(:yandex_translator, :subscription_key)
    url = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=#{key}&text=#{args[:text]}&lang=#{args[:to]}"
    options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
    case HTTPoison.get(url, [], options) do
      {:ok, response} -> parse(response)
      {:error, _} -> "Error"
    end
  end

  defp parse(%{body: json_response}) do
    Poison.Parser.parse(json_response)
  end
end
