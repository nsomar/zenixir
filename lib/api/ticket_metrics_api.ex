
defmodule Zendesk.TicketMetricsApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk ticket metrics
  """

  @endpoint "/ticket_metrics.json"
  @metric_for_id "/ticket_metrics/%s.json"
  @ticket_metrics "/tickets/%s/metrics.json"
  use Zendesk.CommonApi


  @doc """
  Get all metrics
  """
  def all_metrics(account) do
    perform_request(&parse_metrics/1, account: account, verb: :get, endpoint: @endpoint)
  end

  @doc """
  Get metrics for ticket id
  """
  def metrics_for_ticket(account, ticket_id: ticket_id) do
    perform_request(&parse_metric/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@ticket_metrics, [ticket_id]))
  end

  @doc """
  Get metrics with id
  """
  def metrics_with_id(account, id: metric_id) do
    perform_request(&parse_metric/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@metric_for_id, [metric_id]))
  end

  # Private

  defp parse_metric(response) do
    Zendesk.TicketMetrics.from_json(response)
  end

  defp parse_metrics(response) do
    Zendesk.TicketMetrics.from_json_array(response)
  end

end
