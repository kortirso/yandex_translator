defmodule YandexTranslator.Client do
  @moduledoc """
  Client requests for old version of api, v1.5
  """

  @type api_key :: {:api_key, String.t()}
  @type path :: String.t()

  @doc """
  Performs a request

  ## Examples

      iex> YandexTranslator.Client.call("langs", args)

  """
  @spec call(String.t(), list) :: {}

  def call(type, args) when type in ["langs", "detect", "translate"] and is_list(args) do
    type
    |> generate_url(args)
    |> fetch(args[:format])
    |> parse(args[:format])
  end

  # MAIN FUNCTIONS

  # generate url with all params
  defp generate_url(type, args) do
    args
    |> Keyword.put_new(:key, api_key())
    |> Stream.filter(fn {key, _} -> Enum.member?(valid_args(type), key) end)
    |> Stream.map(fn {key, value} -> "#{key}=#{URI.encode_www_form(value)}" end)
    |> Enum.join("&")
    |> prepare_url(type)
  end

  defp fetch(url, format) do
    case HTTPoison.post(base_url(format) <> url, "", []) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{body: body}} -> {:error, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  defp parse({result, response}, "json"), do: {result, Poison.Parser.parse!(response)}
  defp parse(response, _), do: response

  # ADDITIONAL FUNCTIONS

  # list with available options based on request type
  defp valid_args(type) do
    case type do
      "langs" -> [:key, :ui]
      "detect" -> [:key, :text, :hint]
      "translate" -> [:key, :text, :lang]
      _ -> []
    end
  end

  # add type of request to url
  defp prepare_url(url, type) do
    case type do
      "langs" -> "/getLangs?#{url}"
      "detect" -> "/detect?#{url}"
      "translate" -> "/translate?#{url}"
      _ -> ""
    end
  end

  # define params for request
  defp base_url("json"), do: "https://translate.yandex.net/api/v1.5/tr.json"
  defp base_url(_), do: "https://translate.yandex.net/api/v1.5/tr"
  
  # API KEY from config
  defp api_key, do: Application.get_env(:yandex_translator, :api_key) || ""
end
