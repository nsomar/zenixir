defmodule Zendesk.TicketMetrics do
  @moduledoc """
  Zendesk Ticket Metrics
  """


  @doc """
  Decode a JSON to a Map

  `json`: the json to parse
  """
  def from_json_array(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:ticket_metrics)
  end

  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:ticket_metric)
  end

end
