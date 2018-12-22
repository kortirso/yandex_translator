defmodule YandexTranslator.Client do
  @moduledoc """
  Client requests for old varsion of api, v 1.5
  """

  @options [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]

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
    |> Enum.filter(fn({key, _}) -> Enum.member?(valid_args(type), key) end)
    |> List.foldl("", fn({key, value}, acc) -> acc <> add_to_args(key, to_string(value), acc) end)
    |> prepare_url(type)
  end

  defp fetch(url, format) do
    case HTTPoison.post(base_url(format) <> url, "", [], @options) do
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

  # first param in url params
  defp add_to_args(key, value, ""), do: "?" <> key_value_param(key, modify_search(value))
  defp add_to_args(key, value, _), do: "&" <> key_value_param(key, modify_search(value))

  # Modify all phrases with replacing spaces for +
  defp modify_search(value), do: String.replace(value, ~r/\s+/, "+")

  # Attach keys and values for url params string
  defp key_value_param(key, value), do: "#{key}=#{value}"

  # add type of request to url
  defp prepare_url(url, type), do: add_type_to_url(type) <> url

  defp add_type_to_url(type) do
    case type do
      "langs" -> "/getLangs"
      "detect" -> "/detect"
      "translate" -> "/translate"
      _ -> ""
    end
  end

  # define params for request
  defp base_url("json"), do: "https://translate.yandex.net/api/v1.5/tr.json"
  defp base_url(_), do: "https://translate.yandex.net/api/v1.5/tr"
  
  # API KEY from config
  defp api_key, do: Application.get_env(:yandex_translator, :api_key) || ""
end
