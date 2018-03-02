defmodule YandexTranslator.Langs do
  @moduledoc """
  Module for getting available languages for translation
  """

  def run do
    url = "https://translate.yandex.net/api/v1.5/tr.json/getLangs?key=#{ Application.get_env(:yandex_translator, :subscription_key)}"
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
