defmodule Zendesk.User do
  @moduledoc """
  Zendesk User
  """

  @doc """
  Decode a JSON to a Map

  `json`: the json to parse
  """
  def from_json_array(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:users)
  end

  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:user)
  end

end
