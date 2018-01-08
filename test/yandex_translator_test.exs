defmodule YandexTranslatorTest do
  use ExUnit.Case
  doctest YandexTranslator

  test "greets the world" do
    assert YandexTranslator.hello() == :world
  end
end
