# YandexTranslator

A simple Elixir interface to Yandex Translate's translation API

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `yandex_translator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:yandex_translator, "~> 0.9.5"}
  ]
end
```

## Get access to API

### Getting a Cloud Key and Folder ID (for cloud API)

To sign up go [here](https://cloud.yandex.com/docs/translate/concepts/auth)

### Getting a Subscription Key (for old API)

To sign up go [here](https://translate.yandex.ru/developers/keys)

## Configuration

The default behaviour is to configure using the application environment:

In config/config.exs, add:

```elixir
  # for configuring access to cloud api
  config :yandex_translator, cloud_api_key: "API_KEY"
  config :yandex_translator, cloud_folder_id: "FOLDER_ID"

  # for configuring access to old api
  config :yandex_translator, api_key: "API_KEY"
```

## Usage

### Get IAM-token for cloud API access

Request for getting list of supported languages is #langs.

```elixir
  YandexTranslator.get_iam_token
```

#### Options

    key - API KEY, required or optional (if presented in configuration)

### Supported languages

Request for getting list of supported languages is #langs.
For using cloud api options must contain iam_token param.

```elixir
  # cloud api request
  YandexTranslator.langs([iam_token: ""])

  # old api request
  YandexTranslator.langs([])
```

#### Options for cloud api

    iam_token - IAM-token, required
    folder_id - folder ID of your account at Yandex.Cloud, required or optional (if presented in configuration)

#### Options for old api

    key - access key, required or optional (if presented in config)
    format - one of the [xml|json], default - xml, optional
    ui - language code for getting language translations, optional, example - "en"

### Detection

Request for detecting language of text is #detect.
For using cloud api options must contain iam_token param.

```elixir
  # cloud api request
  YandexTranslator.detect([iam_token: "", text: "Hello"])

  # old api request
  YandexTranslator.detect([text: "Hello"])
```

#### Options for cloud api

    iam_token - IAM-token, required
    folder_id - folder ID of your account at Yandex.Cloud, required or optional (if presented in configuration)
    text - text for detection, required
    hint - list of possible languages, optional, example - "en,ru"

#### Options for old api

    key - access key, required or optional (if presented in config)
    format - one of the [xml|json], default - xml, optional
    text - text, required
    hint - list of possible languages, optional, example - "en,ru"

### Translation

Request for translating text is #translate.
For using cloud api options must contain iam_token param.

```elixir
  # cloud api request
  YandexTranslator.translate([iam_token: "", text: "Hello", target: "ru"])

  # old api request
  YandexTranslator.translate([text: "Hello", lang: "en-ru"])
```
#### Options for cloud api

    iam_token - IAM-token, required
    folder_id - folder ID of your account at Yandex.Cloud, required or optional (if presented in configuration)
    text - text for detection, required
    source - source language, ISO 639-1 format (like "en"), optional
    target - target language, ISO 639-1 format (like "ru"), required
    format - text format, one of the [plain|html], default - plain, optional

#### Options for old api

    key - access key, required or optional (if presented in config)
    format - one of the [xml|json], default - xml, optional
    text - text, required
    lang - direction of translation, required, example - "from-to" or "to"

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
