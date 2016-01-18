
defmodule Zendesk.TicketFieldsApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk ticket fields
  """

  @all_fields "/ticket_fields.json"
  @get_field "/ticket_fields/%s.json"
  @update_field "/ticket_fields/%s.json"
  @create_field "/ticket_fields.json"

  use Zendesk.CommonApi
  alias Zendesk.TicketField


  @doc """
  Get all ticket fields
  """
  def all_ticket_fields(account) do
    perform_request(&parse_ticket_fields/1, account: account, verb: :get, endpoint: @all_fields)
  end

  @doc """
  Get a single ticket field

  `ticket_id` ticked id to return fields for
  """
  def all_ticket_fields(account, ticket_id: ticket_id) do
    perform_request(&parse_ticket_field/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@get_field, [ticket_id]))
  end

  @doc """
  Create a ticket field

  `ticket_field` ticket field to create
  """
  def create_ticket_field(account, ticket_field: ticket_field) do
    json = TicketField.to_json(%{ticket_field: ticket_field})

    perform_request(&parse_ticket_field/1, account: account, verb: :post,
    body: json, endpoint: @create_field, headers: headers)
  end

  @doc """
  Update a ticket field

  `ticket_field` ticket field to update

  `field_id` the ticket field id to update
  """
  def update_ticket_field(account, field_id: field_id, ticket_field: ticket_field) do
    json = TicketField.to_json(%{ticket_field: ticket_field})

    perform_request(&parse_ticket_field/1, account: account, verb: :put,
    body: json,
    endpoint: ExPrintf.sprintf(@update_field, [field_id]),
    headers: headers)
  end

  @doc """
  Delete a ticket field

  `field_id` field id to delelte
  """
  def delete_ticket_field(account, field_id: field_id) do
    perform_request(&parse_ticket_delete/1, account: account, verb: :delete,
    endpoint: ExPrintf.sprintf(@get_field, [field_id]))
  end

  # Private

  defp headers do
    ["Content-Type": "application/json"]
  end

  defp parse_ticket_delete(response) do
    response
  end

  defp parse_ticket_fields(response) do
    Zendesk.TicketField.from_json_array(response)
  end

  defp parse_ticket_field(response) do
    Zendesk.TicketField.from_json(response)
  end

end
