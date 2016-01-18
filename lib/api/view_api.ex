
defmodule Zendesk.ViewApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk views
  """

  @all_views "/views.json"
  @preview_view "/views/preview.json"
  @preview_count_view "/views/preview/count.json"
  @create_view "/views.json"
  @active_views "/views/active.json"
  @compact_views "/views/compact.json"
  @get_view "/views/%s.json"
  @execute_view "/views/%s/execute.json"
  @view_tickets "/views/%s/tickets.json"
  @count_views "/views/count_many.json?ids=%s"
  @update_view "/views/%s.json"
  @count_view "/views/%s/count.json"

  use Zendesk.CommonApi
  alias Zendesk.View


  @doc """
  Get all the views
  """
  def all_views(account) do
    perform_request(&parse_get_views/1, account: account, verb: :get, endpoint: @all_views)
  end

  @doc """
  Get the active views
  """
  def active_views(account) do
    perform_request(&parse_get_views/1, account: account, verb: :get, endpoint: @active_views)
  end

  @doc """
  Get the compact views
  """
  def compact_views(account) do
    perform_request(&parse_get_views/1, account: account, verb: :get, endpoint: @compact_views)
  end

  @doc """
  Get a view

  `view_id` the view id
  """
  def show_view(account, view_id: view_id) do
    perform_request(&parse_get_view/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@get_view, [view_id]))
  end

  @doc """
  Creates a view

  `view` the view to create
  """
  def create_view(account, view) do
    perform_request(&parse_get_view/1, account: account, verb: :post,
    endpoint: @create_view,
    headers: headers,
    body: View.to_json(view))
  end

  @doc """
  Preview a view

  `view` the view to preview
  """
  def preview_view(account, view) do
    perform_request(&parse_get_tickets/1, account: account, verb: :post,
    endpoint: @preview_view,
    headers: headers,
    body: View.to_json(view))
  end

  @doc """
  Count a preview a view tickets

  `view` the view to preview
  """
  def count_view_preview(account, view) do
    perform_request(&parse_view_count/1, account: account, verb: :post,
    endpoint: @preview_count_view,
    headers: headers,
    body: View.to_json(view))
  end

  @doc """
  Update a view

  `view_id` the view id to update

  `view` the view to update
  """
  def update_view(account, view_id: view_id, view: view) do
    perform_request(&parse_get_view/1, account: account, verb: :put,
    endpoint: ExPrintf.sprintf(@update_view, [view_id]),
    headers: headers,
    body: View.to_json(view))
  end

  @doc """
  Delete a view

  `view_id` the view id to update
  """
  def delete_view(account, view_id: view_id) do
    perform_request(&parse_delete_view/1, account: account, verb: :delete,
    endpoint: ExPrintf.sprintf(@update_view, [view_id]))
  end

  @doc """
  Execute a view

  `view_id` the view id to execute
  """
  def execute_view(account, view_id: view_id) do
    perform_request(&parse_get_tickets/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@execute_view, [view_id]))
  end

  @doc """
  Execute a view

  `view_id` the view id to execute
  """
  def view_tickets(account, view_id: view_id) do
    perform_request(&parse_get_view_tickets/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@view_tickets, [view_id]))
  end

  @doc """
  Count views

  `view_ids` the view ids to count
  """
  def count_views(account, ids: ids) do
    ids_strings = Enum.join(ids, ",")
    perform_request(&parse_views_count/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@count_views, [ids_strings]))
  end

  @doc """
  Count a single view

  `view_ids` the view ids to count
  """
  def count_view(account, view_id: view_id) do
    perform_request(&parse_view_count/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@count_view, [view_id]))
  end

  # Private

  defp headers do
    ["Content-Type": "application/json"]
  end

  defp parse_views_count(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1) |> Dict.get(:view_counts)
  end

  defp parse_view_count(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1) |> Dict.get(:view_count)
  end

  defp parse_delete_view(response) do
    response
  end

  defp parse_get_view(response) do
    Zendesk.View.from_json(response)
  end

  defp parse_get_views(response) do
    Zendesk.View.from_json_array(response)
  end

  defp parse_get_tickets(response) do
    Zendesk.Ticket.from_json_array(response, :rows)
  end

  defp parse_get_view_tickets(response) do
    Zendesk.Ticket.from_json_array(response, :tickets)
  end

end
