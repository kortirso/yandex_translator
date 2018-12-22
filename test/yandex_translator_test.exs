defmodule YandexTranslatorTest do
  use ExUnit.Case

  setup_all do
    {:ok, %{"iamToken" => iam_token}} = YandexTranslator.get_iam_token
    {:ok, iam_token: iam_token}
  end

  describe "cloud api" do
    test "request for getting languages with invalid key" do
      {:error, %{"error_code" => error_code, "error_message" => error_message}} = YandexTranslator.langs([iam_token: ""])

      assert error_code == "FORBIDDEN"
      assert error_message == "You need send token and folder id"
    end

    test "request for detecting language with invalid key" do
      {:error, %{"error_code" => error_code, "error_message" => error_message}} = YandexTranslator.detect([iam_token: "", text: "Hello"])

      assert error_code == "FORBIDDEN"
      assert error_message == "You need send token and folder id"
    end

    test "request for translating text with invalid key" do
      {:error, %{"error_code" => error_code, "error_message" => error_message}} = YandexTranslator.translate([iam_token: "", text: "Hello", lang: "ru"])

      assert error_code == "FORBIDDEN"
      assert error_message == "You need send token and folder id"
    end

    test "request for getting languages", state do
      {:ok, %{"languages" => languages}} = YandexTranslator.langs([iam_token: state[:iam_token]])

      assert is_list(languages) == true
    end


    test "request for detecting language", state do
      {:ok, %{"language" => language}} = YandexTranslator.detect([iam_token: state[:iam_token], text: "Hello"])

      assert language == "en"
    end

    test "request for translating text", state do
      {:ok, %{"translations" => [%{"text" => text}]}} = YandexTranslator.translate([iam_token: state[:iam_token], text: "Hello", target: "es"])

      assert text == "Saludar"
    end
  end

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
