defmodule YandexTranslator.Cloud do
  @moduledoc """
  Cloud requests for new version of api
  """

  @iam_token_url "https://iam.api.cloud.yandex.net/iam/v1/tokens"
  @cloud_base_url "https://translate.api.cloud.yandex.net/translate/v1/"
  @iam_token_headers [{"Content-Type", "application/json"}]

  @doc """
  Get IAM-token

  ## Examples

      iex> YandexTranslator.Cloud.get_iam_token([])
      {:ok, %{"iamToken" => ""}}

  """
  @spec get_iam_token(keyword()) :: {:ok, %{iamToken: String.t()}}

  def get_iam_token(args) when is_list(args) do
    args[:key]
    |> fetch_iam_token()
    |> parse()
  end

  defp fetch_iam_token(api_key) do
    body = Poison.encode!(%{"yandexPassportOauthToken" => cloud_api_key(api_key)})
    case HTTPoison.post(@iam_token_url, body, @iam_token_headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{body: body}} -> {:error, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  defp cloud_api_key(api_key), do: api_key || Application.get_env(:yandex_translator, :cloud_api_key) || ""

  @doc """
  Performs a request

  ## Examples

      iex> YandexTranslator.Cloud.call("languages", args)

  """
  @spec call(String.t(), list) :: {:ok, %{}}

  def call(type, args) when type in ["languages", "detect", "translate"] and is_list(args) do
    type
    |> fetch(args)
    |> parse()
  end

  # MAIN FUNCTIONS

  # make request
  defp fetch(type, args) do
    case HTTPoison.post(@cloud_base_url <> type, body(args, type), headers(args[:iam_token])) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{body: body}} -> {:error, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  # parse results
  defp parse({result, response}), do: {result, Poison.Parser.parse!(response)}

  # ADDITIONAL FUNCTIONS

  # generate body for request
  defp body(args, type) do
    args
    |> Keyword.put(:folderId, cloud_folder_id(args[:folder_id]))
    |> Enum.filter(fn {key, _} -> Enum.member?(valid_args(type), key) end)
    |> Enum.map(fn {key, value} -> "#{key}=#{value}" end)
    |> Enum.join("&")
  end

  # list with available options based on request type
  defp valid_args(type) do
    case type do
      "languages" -> [:folderId]
      "detect" -> [:folderId, :text, :hint]
      "translate" -> [:folderId, :text, :source, :target, :format]
      _ -> []
    end
  end

  defp cloud_folder_id(folder_id), do: folder_id || Application.get_env(:yandex_translator, :cloud_folder_id) || ""

  # define headers for request
  defp headers(iam_token), do: [{"Content-Type", "application/x-www-form-urlencoded"}, {"Authorization", "Bearer #{iam_token}"}]
end
