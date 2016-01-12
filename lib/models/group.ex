defmodule Zendesk.Group do
  @moduledoc """
  Zendesk Group
  """

  defstruct [:id, :url, :name, :email, :deleted, :created_at, :updated_at]


  @doc """
  Decode a JSON to a Zendesk.Group

  `json`: the json to parse
  """
  def from_json(json) do
    Poison.decode!(json, as: %{"groups" => [Zendesk.Group]})["groups"]
  end

end
