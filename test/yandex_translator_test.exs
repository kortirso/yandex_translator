defmodule YandexTranslatorTest do
  use ExUnit.Case

  test "makes request for getting languages without key" do
    {code, body} = YandexTranslator.langs(format: "json")
    assert code == :error
    assert body["code"] == 502
    assert body["message"] == "Invalid parameter: key"
  end

  test "makes request for getting languages without key, xml format" do
    {code, body} = YandexTranslator.langs(format: "xml")
    assert code == :error
    assert String.length(body) != 0
  end

  test "makes request for detecting language without key" do
    {code, body} = YandexTranslator.detect(text: "Hello", format: "json")
    assert code == :error
    assert body["code"] == 502
    assert body["message"] == "Invalid parameter: key"
  end

  test "makes request for detecting language without key, xml format" do
    {code, body} = YandexTranslator.detect(text: "Hello", format: "xml")
    assert code == :error
    assert String.length(body) != 0
  end

  test "makes request for translating text without key" do
    {code, body} = YandexTranslator.detect(text: "Hello", lang: "ru", format: "json")
    assert code == :error
    assert body["code"] == 502
    assert body["message"] == "Invalid parameter: key"
  end

  test "makes request for translating text without key, xml format" do
    {code, body} = YandexTranslator.detect(text: "Hello", lang: "ru", format: "xml")
    assert code == :error
    assert String.length(body) != 0
  end
end
