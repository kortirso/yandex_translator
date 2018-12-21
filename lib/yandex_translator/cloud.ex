defmodule YandexTranslator.Cloud do
  @moduledoc """
  Cloud requests for new version of api
  """

  def call(type, args) when type in ["langs", "detect", "translate"] and is_list(args) do
  end
end
