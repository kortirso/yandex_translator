defmodule YandexTranslator do
  @moduledoc """
  Functions for requests to Yandex.Translator API
  """

  @doc """
  Getting available languages for translation
  """
  @spec langs(keyword()) :: tuple()

  def langs(args \\ []) do
    args
    |> check_args_for_key
    |> call("langs")
  end

  @doc """
  Language detection for text
  """
  @spec detect(keyword()) :: tuple()

  def detect(args \\ []) do
    args
    |> check_args_for_key
    |> call("detect")
  end

  @doc """
  Text translation
  """
  @spec translate(keyword()) :: tuple()

  def translate(args \\ []) do
    args
    |> check_args_for_key
    |> call("translate")
  end

  defp check_args_for_key(args) do
    if args[:key] == nil do
      Keyword.put_new(args, :key, Application.get_env(:yandex_translator, :subscription_key))
    end
    args
  end

  defp call(args, type) do
    type
    |> generate_url(args)
    |> prepare_url(type)
    |> fetch(args)
    |> parse(args[:format])
  end

  defp generate_url(type, args) do
    Enum.filter(args, fn({key, _value}) -> Enum.member?(valid_args(type), key) end)
    |> List.foldl("", fn({key, value}, acc) -> acc <> add_to_options(key, to_string(value), acc) end)
  end

  defp valid_args(type) do
    case type do
      "langs" -> [:key, :ui]
      "detect" -> [:key, :text, :hint]
      "translate" -> [:key, :text, :lang]
      _ -> []
    end
  end

  defp add_to_options(key, value, "") do
    "?" <> key_value_param(key, modify_search(value))
  end

  defp add_to_options(key, value, _acc) do
    "&" <> key_value_param(key, modify_search(value))
  end

  defp modify_search(value) do
    String.replace(value, ~r/\s+/, "+")
  end

  defp key_value_param(key, value) do
    "#{key}=#{value}"
  end

  defp prepare_url(url, type) do
    api_endpoints(type) <> url
  end

  defp api_endpoints(type) do
    case type do
      "langs" -> "/getLangs"
      "detect" -> "/detect"
      "translate" -> "/translate"
      _ -> ""
    end
  end

  defp fetch(url, args) do
    base_url = define_url_for_format(args[:format])
    options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
    case HTTPoison.post(base_url <> url, "", [], options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{body: body}} -> {:error, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  defp define_url_for_format(format) when format == "json" do
    "https://translate.yandex.net/api/v1.5/tr.json"
  end

  defp define_url_for_format(_format) do
    "https://translate.yandex.net/api/v1.5/tr"
  end

  defp parse({result, response}, format) do
    if format == "json" do
      {result, Poison.Parser.parse!(response)}
    else
      {result, response}
    end
  end
end
