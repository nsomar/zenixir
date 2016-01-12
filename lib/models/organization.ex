defmodule Zendesk.Organization do
  @moduledoc """
  Zendesk Organization
  """


  @doc """
  Decode a JSON to a Map

  `json`: the json to parse
  """
  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:organizations)
  end
  
end
