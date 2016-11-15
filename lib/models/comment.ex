defmodule Zendesk.Comment do
  @moduledoc """
  Zendesk Comment module
  """

  def from_json("{}") do
  	%{}
  end
  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:comment)
  end

  def from_json_array(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:comments)
  end
end