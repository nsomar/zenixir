
defmodule Zendesk.TargetsApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk searches
  """

  @list_targets "/targets.json"
  @show_targets "/targets/%s.json"
  @create_target "/targets.json"
  @update_target "/targets/%s.json"
  @reorder_targets "/targets/reorder.json"
  use Zendesk.CommonApi


  @doc """
  List targets

  `account`: The Zendesk.Account to use

  """
  def list_targets(account) do
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :get, 
                    endpoint: @list_targets)
  end

  @doc """
  Get targets

  `account`: The Zendesk.Account to use

  `ticket_id`: ticket_id

  """
  def show_target(account, id) do
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :get, 
                    endpoint: ExPrintf.sprintf(@show_targets, [id]))
  end

  @doc """
  Create targets

  `account`: The Zendesk.Account to use

  `target`: target

  """
  def create_target(account, target) do
    json = Zendesk.Ticket.to_json(%{target: target})
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :post, 
                    endpoint: @create_target, 
                    body: json, 
                    headers: headers)
  end

  @doc """
  Update targets

  `account`: The Zendesk.Account to use

  `target`: target

  `target_id`: target_id

  """

  def update_target(account, target, target_id) do
    json = Zendesk.Ticket.to_json(%{target: target})
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :put, 
                    endpoint: ExPrintf.sprintf(@update_target, [target_id]), 
                    body: json, 
                    headers: headers)
  end

  @doc """
  Delete targets

  `account`: The Zendesk.Account to use

  `target_id`: target_id

  """

  def delete_target(account, target_id) do
    perform_request(&parse_delete/1, 
                    account: account, 
                    verb: :delete, 
                    endpoint: ExPrintf.sprintf(@delete_target, [target_id]), 
                    headers: headers)
  end

  defp headers do
    ["Content-Type": "application/json"]
  end
  defp parse_delete(response) do
    response
  end

end