defmodule YandexTranslatorTest do
  use ExUnit.Case

  describe "old api, invalid requests" do
    test "request for getting languages with invalid key" do
      {:error, %{"code" => code, "message" => message}} = YandexTranslator.langs([key: "", format: "json"])

      assert code == 401
      assert message == "API key is invalid"
    end

    test "request for getting languages with invalid key, xml format" do
      {:error, body} = YandexTranslator.langs([key: ""])

      assert String.length(body) != 0
    end

    test "request for detecting language with invalid key" do
      {:error, %{"code" => code, "message" => message}} = YandexTranslator.detect([key: "", text: "Hello", format: "json"])

      assert code == 401
      assert message == "API key is invalid"
    end

    test "request for detecting language with invalid key, xml format" do
      {:error, body} = YandexTranslator.detect([key: "", text: "Hello"])

      assert String.length(body) != 0
    end

    test "request for translating text with invalid key" do
      {:error, %{"code" => code, "message" => message}} = YandexTranslator.translate([key: "", text: "Hello", lang: "ru", format: "json"])

      assert code == 401
      assert message == "API key is invalid"
    end

    test "request for translating text with invalid key, xml format" do
      {:error, body} = YandexTranslator.translate([key: "", text: "Hello", lang: "ru"])

      assert String.length(body) != 0
    end
  end

  describe "old api, valid requests" do
    test "request for getting languages" do
      {:ok, %{"dirs" => dirs}} = YandexTranslator.langs([format: "json"])

      assert is_list(dirs) == true
    end

    test "request for getting languages, xml format" do
      {:ok, body} = YandexTranslator.langs

      assert String.length(body) != 0
    end

    test "request for detecting language" do
      {:ok, %{"code" => code, "lang" => lang}} = YandexTranslator.detect([text: "Hello", format: "json"])

      assert code == 200
      assert lang == "en"
    end

    test "request for detecting language, xml format" do
      {:ok, body} = YandexTranslator.detect([text: "Hello"])

      assert String.length(body) != 0
    end

    test "request for translating text" do
      {:ok, %{"code" => code, "lang" => lang, "text" => text}} = YandexTranslator.translate([text: "Hello", lang: "ru", format: "json"])

      assert code == 200
      assert lang == "en-ru"
      assert text == ["Привет"]
    end

    test "request for translating text, xml format" do
      {:ok, body} = YandexTranslator.translate([text: "Hello", lang: "ru"])

      assert String.length(body) != 0
    end
  end
end
