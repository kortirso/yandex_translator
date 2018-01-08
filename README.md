# YandexTranslator

A simple Elixir interface to Yandex Translator's translation API

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `yandex_translator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:yandex_translator, "~> 0.1.0"}
  ]
end
```

## Getting a Subscription Key

To sign up for the free tier, do the following:

- Text Translator is [here](https://translate.yandex.ru/developers/keys)

## Usage

```elixir
# Request for getting possible translation directions
YandexTranslator.langs

# Request for detecting language of the text
# text - text for detecting, required
# hint - list of possible languages, optional
YandexTranslator.detect(text: "Hello")

# Request for translating of the text
# text - text for detecting, required
# to - translating direction, required
# from - language of the text, optional
YandexTranslator.translate(text: "Hello", to: "ru")
```

## Configuration

The default behaviour is to configure using the application environment:

In config/config.exs, add:

```elixir
config :bing_translator,
  subscription_key: "Your-Subscription-Key",
  http_client_options: []  #  [ssl: [{:versions, [:"tlsv1.2"]}]]
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/yandex_translator](https://hexdocs.pm/yandex_translator).
