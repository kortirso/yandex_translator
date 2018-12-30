defmodule YandexTranslator.Mixfile do
  use Mix.Project

  @description """
    Translate word and phrases using the Yandex Translate API. Requires that you have a Client ID. See README.md for information.
  """

  def project do
    [
      app: :yandex_translator,
      version: "0.9.4",
      elixir: "~> 1.7",
      description: @description,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      package: package(),
      deps: deps(),
      source_url: "https://github.com/kortirso/yandex_translator"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:poison, "~> 3.1.0"},
      {:ex_doc, "~> 0.19", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Bogdanov Anton"],
      licenses: ["MIT"],
      links: %{"github" => "https://github.com/kortirso/yandex_translator"}
    ]
  end
end
