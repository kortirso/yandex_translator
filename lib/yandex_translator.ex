defmodule YandexTranslator do
  @moduledoc """
  Documentation for YandexTranslator.
  """

  defdelegate langs, to: YandexTranslator.Langs, as: :run
  defdelegate detect(args), to: YandexTranslator.Detect, as: :run
  defdelegate translate(args), to: YandexTranslator.Translate, as: :run
end
