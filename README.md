# YandexTranslator

A simple Elixir interface to Yandex Translate's translation API

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `yandex_translator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:yandex_translator, "~> 0.9.1"}
  ]
end
```

## Getting a Subscription Key

To sign up for the free tier go [here](https://translate.yandex.ru/developers/keys)

## Usage

### Supported languages

Request for getting list of supported languages is #langs.

```elixir
  YandexTranslator.langs
```
    key - access key, required or optional (if presented in config)
    format - one of the [xml|json], default - xml
    ui - language code for getting language translations, example - "en"

#### Responces

```elixir
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
```

### Detection

Request for detecting language of text is #detect.

```elixir
  YandexTranslator.detect([text: "Hello"])
```
    key - access key, required or optional (if presented in config)
    format - one of the [xml|json], default - xml
    text - text, required
    hint - list of possible languages, optional, example - "en,ru"

#### Responces

```elixir
  {:ok,
    %{
      "code" => 200,
      "lang" => "en"
    }
  }
```

### Translation

Request for translating text is #translate.

```elixir
  YandexTranslator.translate([text: "Hello", lang: "en-ru"])
```
    key - access key, required or optional (if presented in config)
    format - one of the [xml|json], optional, default - xml
    text - text, required
    lang - direction of translation, required, example - "from-to" or "to"

#### Responces

```elixir
  {:ok,
    %{
      "code" => 200,
      "lang" => "en-ru",
      "text" => ["Привет"]
    }
  }
```

## Configuration

The default behaviour is to configure using the application environment:

In config/config.exs, add:

```elixir
config :yandex_translator, api_key: "API_KEY"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kortirso/yandex_translator.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Disclaimer

Use this package at your own peril and risk.

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/yandex_translator](https://hexdocs.pm/yandex_translator).
