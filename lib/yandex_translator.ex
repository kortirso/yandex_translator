defmodule YandexTranslator do
  @moduledoc """
  Elixir client for Yandex.Translate API
  """

  alias OpenStreetMap.{Client, Cloud}

  @doc """
  Getting available languages for translation

  ## Example

      iex> YandexTranslator.langs

      iex> YandexTranslator.langs([cloud: true])

  """
  @spec search(keyword()) :: tuple()
  @spec langs(keyword()) :: tuple()

  def langs(options) when is_list(options) do
    case options[:cloud] do
      true -> Cloud.call("languages")
      _ -> Client.call("langs", options)
    end
  end

  @doc """
  Language detection for text

  ## Example

      iex> YandexTranslator.detect

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

  ## Example

      iex> YandexTranslator.translate

      iex> YandexTranslator.translate([cloud: true])

  """
  @spec translate(keyword()) :: tuple()

  def translate(options) when is_list(options), do
    case options[:cloud] do
      true -> Cloud.call("translate", options)
      _ -> Client.call("translate", options)
    end
  end
end
