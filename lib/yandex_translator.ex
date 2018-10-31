defmodule YandexTranslator do
  @moduledoc """
  Functions for requests to Yandex.Translator API
  """

  @doc """
  Getting available languages for translation
  """
  @spec langs(keyword()) :: tuple()

  def langs(args) do
    call("langs", args)
  end

  def langs() do
    call("langs", key: "")
  end

  defp call(type, args) do
    type
    |> generate_url(args)
    |> prepare_url(type)
    |> fetch(args[:format])
    |> parse(args[:format])
  end

  defp generate_url(type, args) do
    Enum.filter(args, fn({key, _value}) -> Enum.member?(valid_args(type), key) end)
    |> List.foldl("", fn({key, value}, acc) -> acc <> add_to_options(key, to_string(value), acc) end)
  end

  defp valid_args(type) do
    case type do
      "langs" -> [:key, :ui]
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
      _ -> ""
    end
  end

  defp fetch(url, format) do
    base_url = define_url_for_format(format)
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

  defp parse({result, response}, format) when result == :ok do
    if format == "json" do
      {:ok, Poison.Parser.parse!(response)}
    else
      {:ok, response}
    end
  end

  defp parse(response, _format) do
    response
  end
end
