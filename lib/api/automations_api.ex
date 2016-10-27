
defmodule Zendesk.AutomationsApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk searches
  """

  @list_automations "/automations.json"
  @get_automations "/automations/%s.json"
  @list_active_automations "/automations/active.json"
  @create_automation "/automations.json"
  @update_automation "/automations/%s.json"
  @delete_automation "/automations/%s.json"
  use Zendesk.CommonApi


  @doc """
  List automations

  `account`: The Zendesk.Account to use

  """
  def list_automations(account) do
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :get, 
                    endpoint: @list_automations)
  end

  @doc """
  Get automations

  `account`: The Zendesk.Account to use

  `ticket_id`: ticket_id

  """
  def get_automations(account, automation_id) do
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :get, 
                    endpoint: ExPrintf.sprintf(@get_automations, [automation_id]))
  end

  @doc """
  List active utomations

  `account`: The Zendesk.Account to use

  """
  def list_active_automations(account) do
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :get, 
                    endpoint: @list_active_automations)
  end

  @doc """
  Create automations

  `account`: The Zendesk.Account to use

  `automation`: automation

  """
  def create_automation(account, automation) do
    json = Zendesk.Ticket.to_json(%{automation: automation})
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :post, 
                    endpoint: @create_automation, 
                    body: json, 
                    headers: headers)
  end

  @doc """
  Update automation

  `account`: The Zendesk.Account to use

  `automation`: automation

  `automation_id`: automation_id

  """

  def update_automation(account, automation, automation_id) do
    json = Zendesk.Ticket.to_json(%{automation: automation})
    IO.inspect json
    perform_request(&Zendesk.Ticket.incremental_from_json_array/1, 
                    account: account, 
                    verb: :put, 
                    endpoint: ExPrintf.sprintf(@update_automation, [automation_id]), 
                    body: json, 
                    headers: headers)
  end

  @doc """
  Delete automation

  `account`: The Zendesk.Account to use

  `automation_id`: automation_id

  """

  def delete_automation(account, automation_id) do
    perform_request(&parse_delete/1, 
                    account: account, 
                    verb: :delete, 
                    endpoint: ExPrintf.sprintf(@delete_automation, [automation_id]), 
                    headers: headers)
  end

  defp headers do
    ["Content-Type": "application/json"]
  end

  defp parse_delete(response) do
    response
  end


end