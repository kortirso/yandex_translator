defmodule YandexTranslator do
  @moduledoc """
  Elixir client for Yandex.Translate API

  ## Configuration (new API)
  An API key and folder id can be set in your application's config.
  For getting api key and folder is check readme.

      config :yandex_translator, cloud_api_key: "API_KEY"
      config :yandex_translator, cloud_folder_id: "FOLDER_ID"

  ## Configuration (old API)
  An API key can be set in your application's config.
  For getting api key check readme.

      config :yandex_translator, api_key: "API_KEY"

  """

  alias YandexTranslator.{Client, Cloud}

  @doc """
  Get IAM-token for using it in requests to Yandex.Cloud
  Valid 12 hours.

  ## Example

      iex> YandexTranslator.get_iam_token
      {:ok, %{"iamToken" => ""}}

  """
  @spec get_iam_token() :: {:ok, %{iamToken: String.t()}}

  def get_iam_token, do: get_iam_token([])

  @doc """
  Get IAM-token for using it in requests to Yandex.Cloud
  Valid 12 hours.

  ## Example

      iex> YandexTranslator.get_iam_token([])
      {:ok, %{"iamToken" => ""}}

  ### Options

      key - API KEY, required or optional (if presented in configuration)

  """
  @spec get_iam_token(keyword()) :: {:ok, %{iamToken: String.t()}}

  def get_iam_token(options) when is_list(options), do: Cloud.get_iam_token(options)

  @doc """
  Get available languages for translation

  ## Example

      iex> YandexTranslator.langs

  """
  @spec langs() :: {:ok, %{}}

  def langs, do: langs([])

  @doc """
  Get available languages for translation
  For using cloud api options must contain iam_token param.

  ## Example (cloud API)

      iex> YandexTranslator.langs([iam_token: ""])
      {:ok, %{"languages" => [%{"language" => "az"}, %{...}, ...]}}

  ### Options (cloud API)

      iam_token - IAM-token, required
      folder_id - folder ID of your account at Yandex.Cloud, required or optional (if presented in configuration)

  ## Example (old API)

      iex> YandexTranslator.langs([format: "json"])
      {:ok, %{"dirs" => ["az-ru", ...]}}

  ### Options (old API)

      key - API KEY, required or optional (if presented in configuration)
      format - one of the [xml|json], optional, default - xml
      ui - language code for getting language translations, optional, example - "en"

  """
  @spec langs(keyword()) :: {:ok, %{}}

  def langs(options) when is_list(options) do
    case options[:iam_token] do
      nil -> Client.call("langs", options)
      _ -> Cloud.call("languages", options)
    end
  end

  @doc """
  Detect language for text
  For using cloud api options must contain iam_token param.

  ## Example (cloud API)

      iex> YandexTranslator.detect([iam_token: "", text: "Hello"])
      {:ok, %{"language" => "en"}}

  ### Options (cloud API)

      iam_token - IAM-token, required
      folder_id - folder ID of your account at Yandex.Cloud, required or optional (if presented in configuration)
      text - text for detection, required
      hint - list of possible languages, optional, example - "en,ru"

  ## Example (old API)

      iex> YandexTranslator.detect([text: "Hello", format: "json"])
      {:ok, %{"code" => 200, "lang" => "en"}}

  ## Options (old API)

      key - API KEY, required or optional (if presented in config)
      format - one of the [xml|json], optional, default - xml
      text - text for detection, required
      hint - list of possible languages, optional, example - "en,ru"

  """
  @spec detect(keyword()) :: {:ok, %{}}

  def detect(options) when is_list(options) do
    case options[:iam_token] do
      nil -> Client.call("detect", options)
      _ -> Cloud.call("detect", options)
    end
  end

  @doc """
  Translate word or phrase
  For using cloud api options must contain iam_token param.

  ## Example (cloud API)

      iex> YandexTranslator.translate([iam_token: iam_token, text: "hello world", source: "en", target: "es"])
      {:ok, %{"translations" => [%{"text" => "hola mundo"}]}}

  ### Options (cloud API)

      iam_token - IAM-token, required
      folder_id - folder ID of your account at Yandex.Cloud, required or optional (if presented in configuration)
      text - text for detection, required
      source - source language, ISO 639-1 format (like "en"), optional
      target - target language, ISO 639-1 format (like "ru"), required
      format - text format, one of the [plain|html], default - plain, optional

  ## Example (old API)

      iex> YandexTranslator.translate([format: "json", text: "Hello", lang: "en-es"])
      {:ok, %{"code" => 200, "lang" => "en-es", "text" => ["Hola"]}}

  ## Options (old API)

      key - API KEY, required or optional (if presented in config)
      format - one of the [xml|json], optional, default - xml
      text - text, required
      lang - direction of translation, optional, example - "from-to" or "to"

  """
  @spec translate(keyword()) :: {:ok, %{}}

  def translate(options) when is_list(options) do
    case options[:iam_token] do
      nil -> Client.call("translate", options)
      _ -> Cloud.call("translate", options)
    end
  end
end
