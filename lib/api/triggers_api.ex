
defmodule Zendesk.TriggersApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk searches
  """

  @list_triggers "/triggers.json"
  @get_triggers "/triggers/%s.json"
  @create_trigger "/triggers.json"
  @update_trigger "/triggers/%s.json"
  @delete_trigger "/triggers/%s.json"
  use Zendesk.CommonApi


  @doc """
  List Triggers

  `account`: The Zendesk.Account to use

  """
  def list_triggers(account) do
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :get, 
                    endpoint: @list_triggers)
  end

  @doc """
  Get Triggers

  `account`: The Zendesk.Account to use

  `ticket_id`: ticket_id

  """
  def get_triggers(account, id) do
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :get, 
                    endpoint: ExPrintf.sprintf(@get_triggers, [id]))
  end

  @doc """
  Create Triggers

  `account`: The Zendesk.Account to use

  `trigger`: trigger

  """
  def create_trigger(account, trigger) do
    json = Zendesk.Ticket.to_json(%{trigger: trigger})
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :post, 
                    endpoint: @create_trigger, 
                    body: json, 
                    headers: headers)
  end

  @doc """
  Update Triggers

  `account`: The Zendesk.Account to use

  `trigger`: trigger

  `trigger_id`: trigger_id

  """

  def update_trigger(account, trigger, trigger_id) do
    json = Zendesk.Ticket.to_json(%{trigger: trigger})
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :put, 
                    endpoint: ExPrintf.sprintf(@update_trigger, [trigger_id]), 
                    body: json, 
                    headers: headers)
  end

  @doc """
  Delete Triggers

  `account`: The Zendesk.Account to use

  `trigger_id`: trigger_id

  """

  def delete_trigger(account, trigger_id) do
    perform_request(&parse_delete/1, 
                    account: account, 
                    verb: :delete, 
                    endpoint: ExPrintf.sprintf(@delete_trigger, [trigger_id]), 
                    headers: headers)
  end

  defp headers do
    ["Content-Type": "application/json"]
  end

  defp parse_delete(response) do
    response
  end


end