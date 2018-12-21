defmodule YandexTranslator do
  @moduledoc """
  Elixir client for Yandex.Translate API

  ## Configuration (old API)
  An API key can be set in your application's config.

      config :yandex_translator, api_key: "API_KEY"

  """

  alias YandexTranslator.{Client, Cloud}

  @doc """
  Getting available languages for translation

  ## Example

      iex> YandexTranslator.langs

  """
  @spec langs() :: {:ok, %{dirs: []}}

  def langs, do: langs([])

  @doc """
  Getting available languages for translation

  ## Example (old API)

      iex> YandexTranslator.langs([format: "json"])
      {:ok,
        %{
         "dirs" => ["az-ru", "be-bg", "be-cs", "be-de", "be-en", "be-es", "be-fr",
          "be-it", "be-pl", "be-ro", "be-ru", "be-sr", "be-tr", "bg-be", "bg-ru",
          "bg-uk", "ca-en", "ca-ru", "cs-be", "cs-en", "cs-ru", "cs-uk", "da-en",
          "da-ru", "de-be", "de-en", "de-es", "de-fr", "de-it", "de-ru", "de-tr",
          "de-uk", "el-en", "el-ru", "en-be", "en-ca", "en-cs", "en-da", "en-de",
          "en-el", "en-es", "en-et", "en-fi", "en-fr", "en-hu", "en-it", "en-lt", ...]
        }
      }

  ### Options (old API)

      key - API KEY, required or optional (if presented in configuration)
      format - one of the [xml|json], optional, default - xml
      ui - language code for getting language translations, optional, example - "en"

  ## Example (cloud API)

      iex> YandexTranslator.langs([cloud: true])

  """
  @spec langs(keyword()) :: tuple()

  def langs(options) when is_list(options) do
    case options[:cloud] do
      true -> Cloud.call("languages", options)
      _ -> Client.call("langs", options)
    end
  end

  @doc """
  Detect language for text

  ## Example (old API)

      iex> YandexTranslator.detect([text: "Hello", format: "json"])
      {:ok, %{"code" => 200, "lang" => "en"}}

  ## Options (old API)

      key - API KEY, required or optional (if presented in config)
      format - one of the [xml|json], optional, default - xml
      text - text, required
      hint - list of possible languages, optional, example - "en,ru"

  ## Example (cloud API)

      iex> YandexTranslator.detect([cloud: true])

  """
  @spec detect(keyword()) :: tuple()

  def detect(options) when is_list(options) do
    case options[:cloud] do
      true -> Cloud.call("detect", options)
      _ -> Client.call("detect", options)
    end
  end

  @doc """
  Text translation

  ## Example (old API)

      iex> YandexTranslator.translate([format: "json", text: "Hello", lang: "en-es"])
      {:ok, %{"code" => 200, "lang" => "en-es", "text" => ["Hola"]}}

  ## Options (old API)

      key - API KEY, required or optional (if presented in config)
      format - one of the [xml|json], optional, default - xml
      text - text, required
      lang - direction of translation, optional, example - "from-to" or "to"

  ## Example (cloud API)

      iex> YandexTranslator.translate([cloud: true])

  """
  @spec translate(keyword()) :: tuple()

  def translate(options) when is_list(options) do
    case options[:cloud] do
      true -> Cloud.call("translate", options)
      _ -> Client.call("translate", options)
    end
  end
end
