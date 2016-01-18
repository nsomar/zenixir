defmodule Zendesk.Group do
  @moduledoc """
  Zendesk Group
  """


  @doc """
  Decode a JSON to a Zendesk.Group

  `json`: the json to parse
  """
  def from_json_array(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:groups)
  end

  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:group)
  end

end
