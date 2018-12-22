defmodule YandexTranslator.Cloud do
  @moduledoc """
  Cloud requests for new version of api
  """

  @cloud_base_url "https://iam.api.cloud.yandex.net/iam/v1/tokens"
  @iam_token_headers [{"Content-Type", "application/json"}]
  @options [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]

  @doc """
  Get IAM-token

  ## Examples

      iex> YandexTranslator.Cloud.get_iam_token([])
      {:ok, %{"iamToken" => ""}}

  """
  @spec get_iam_token(keyword()) :: {}

  def get_iam_token(args) when is_list(args) do
    args[:key]
    |> fetch_iam_token()
    |> parse()
  end

  defp fetch_iam_token(api_key) do
    body = Poison.encode!(%{"yandexPassportOauthToken" => cloud_api_key(api_key)})
    case HTTPoison.post(@cloud_base_url, body, @iam_token_headers, @options) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{body: body}} -> {:error, body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  defp parse({result, response}), do: {result, Poison.Parser.parse!(response)}

  defp cloud_api_key(api_key), do: api_key || Application.get_env(:yandex_translator, :cloud_api_key) || ""

  def call(type, args) when type in ["langs", "detect", "translate"] and is_list(args) do
  end
end
