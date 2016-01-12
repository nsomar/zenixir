defmodule Zendesk.Error do
  @moduledoc """
  Zendesk Error
  """

  @derive [Poison.Encoder]
  defstruct [:error]


  @doc """
  Decode a JSON to a Zendesk.Error

  `json`: the json to parse
  """
  def from_json(json) do
    Poison.decode!(json, as: Zendesk.Error)
  end

end
