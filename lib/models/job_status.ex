defmodule Zendesk.JobStatus do
  @moduledoc """
  Zendesk Job Status
  """


  @doc """
  Decode a JSON to a Map

  `json`: the json to parse
  """
  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:job_status)
  end

end
