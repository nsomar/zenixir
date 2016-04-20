
defmodule Zendesk.TicketApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk tickets
  """

  use Zendesk.CommonApi
  alias Zendesk.Ticket

  @create_endpoint "/tickets.json"
  @all_endpoint "/tickets.json"
  @recent_endpoint "/tickets/recent.json"
  @by_requester "/users/%s/tickets/requested.json"
  @by_assignee "/users/%s/tickets/assigned.json"
  @by_cc "/users/%s/tickets/ccd.json"
  @for_organization "/organizations/%s/tickets.json"
  @ticket_with_id "/tickets/%s.json"
  @many_tickets "/tickets/show_many.json?ids=%s.json"
  @merge_tickets "/tickets/%s/merge.json"
  @related_tickets "/tickets/%s/related.json"
  @ticket_collaborators "/tickets/%s/collaborators.json"
  @ticket_incidents "/tickets/%s/incidents.json"
  @all_problems "/problems.json"
  @autocomplete_problems "/problems/autocomplete.json"

  @doc """
  Create a ticket

  `ticket`: the ticket to create
  """
  def create_ticket(account, ticket: ticket) do
    json = Ticket.to_json(%{ticket: ticket})
    perform_request(&parse_single_ticket/1, account: account, verb: :post, endpoint: @create_endpoint, body: json, headers: headers)
  end

  @doc """
  Update a ticket.

  `account`: The Zendesk.Account to use

  `ticket`: The ticket object.

  `ticket_id`: the ticket id to update.
  """
  def update_ticket(account, ticket: ticket, ticket_id: ticket_id) do
    json = Ticket.to_json(%{ticket: ticket})
    perform_request(&parse_single_ticket/1, account: account,
    verb: :put,
    endpoint: ExPrintf.sprintf(@ticket_with_id, [ticket_id]),
    body: json, headers: headers)
  end

  @doc """
  Get All Tickets.

  `account`: The Zendesk.Account to use
  """
  def all_tickets(account) do
    perform_request(&parse_multiple_tickets/1, account: account, verb: :get, endpoint: @all_endpoint)
  end

  @doc """
  Get the recent tickets

  `account`: The Zendesk.Account to use
  """
  def recent_tickets(account) do
    perform_request(&parse_multiple_tickets/1, account: account, verb: :get, endpoint: @recent_endpoint)
  end

  @doc """
  Delete a ticket

  `account`: The Zendesk.Account to use

  `ticket_id`: Thec ticket ID to delete
  """
  def delete_ticket(account, ticket_id: ticket_id) do
    perform_request(&parse_delete_ticket/1, account: account, verb: :delete, endpoint: ticket_url(ticket_id))
  end

  @doc """
  Fetch a group of tickets

  `account`: The Zendesk.Account to use

  `ids`: A list of tickets ids to fetch
  """
  def show_tickets(account, ids: ids) do
    ids_strings = Enum.join(ids, ",")
    url = ExPrintf.sprintf(@many_tickets, [ids_strings])

    perform_request(&parse_multiple_tickets/1, account: account, verb: :get,
    endpoint: url)
  end

  @doc """
  Get tickets for a requester

  `account`: The Zendesk.Account to use

  `requester_id`: The requester ID to get the ticket for
  """
  def show_ticket(account, requester_id: requeser_id) do
    perform_request(&parse_multiple_tickets/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@by_requester, [requeser_id]))
  end

  @doc """
  Fetch a ticket with ID

  `account`: The Zendesk.Account to use

  `ticket_id`: Thec ticket ID to fetch
  """
  def show_ticket(account, ticket_id: ticket_id) do
    perform_request(&parse_single_ticket/1, account: account, verb: :get,
    endpoint: ticket_url(ticket_id))
  end

  @doc """
  Get tickets for an assignee

  `account`: The Zendesk.Account to use

  `assignee_id`: The assignee ID to get the ticket for
  """
  def show_ticket(account, assignee_id: assignee_id) do
    perform_request(&parse_multiple_tickets/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@by_assignee, [assignee_id]))
  end

  @doc """
  Get tickets for a ccd user

  `account`: The Zendesk.Account to use

  `cc_id`: The cc id of the user to get the ticket for
  """
  def show_ticket(account, cc_id: cc_id) do
    perform_request(&parse_multiple_tickets/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@by_cc, [cc_id]))
  end

  @doc """
  Get tickets for an organization

  `account`: The Zendesk.Account to use

  `organization_id`: The organization_id to get the tickets for
  """
  def show_ticket(account, organization_id: organization_id) do
    perform_request(&parse_multiple_tickets/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@for_organization, [organization_id]))
  end

  @doc """
  Get tickets related to a ticket

  `account`: The Zendesk.Account to use

  `ticket_id`: The ticket ID to get related tickets for
  """
  def ticket_related(account, ticket_id: ticket_id) do
    perform_request(&parse_related_tickets_info/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@related_tickets, [ticket_id]))
  end

  @doc """
  Get the ticket collaborators

  `account`: The Zendesk.Account to use

  `ticket_id`: The ticket ID to get collaborators for
  """
  def ticket_collaborators(account, ticket_id: ticket_id) do
    perform_request(&parse_collaborators/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@ticket_collaborators, [ticket_id]))
  end

  @doc """
  Get the ticket incidents

  `account`: The Zendesk.Account to use

  `ticket_id`: The ticket ID to get the incidents for
  """
  def ticket_incidents(account, ticket_id: ticket_id) do
    perform_request(&parse_multiple_tickets/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@ticket_incidents, [ticket_id]))
  end

  @doc """
  Get the all the problem tickets

  `account`: The Zendesk.Account to use
  """
  def ticket_problems(account) do
    perform_request(&parse_multiple_tickets/1, account: account, verb: :get,
    endpoint: @all_problems)
  end

  @doc """
  Search the problems using a text query

  `account`: The Zendesk.Account to use

  `text`: The text to search for
  """
  def autocomplete_problems(account, text: text) do
    perform_request(&parse_multiple_tickets/1, account: account,
    verb: :post,
    endpoint: @autocomplete_problems,
    body: autocomplete_body(text: text),
    headers: headers)
  end

  @doc """
  Merge a list of tickets to a parent ticket

  `account`: The Zendesk.Account to use

  `target_id`: The ticket to merge the other tickets into

  `ids`: A list of ticket ids to merge

  `target_comment`: The comment to add to the target ticket

  `source_comment`: The comment to add to the source tickets
  """
  def merge_tickets(account, target_id: target_id, ids: ids,
                             target_comment: target_comment, source_comment: source_comment) do

    perform_request(&parse_job_status_ticket/1,
    account: account, verb: :post,
    endpoint: ExPrintf.sprintf(@merge_tickets, [target_id]),
    body: merge_tickets_body(ids, target_comment, source_comment),
    headers: headers)
  end

  # Private

  defp merge_tickets_body(ids, target_comment, source_comment) do
     %{ids: ids, target_comment: target_comment, source_comment: source_comment}
     |> Poison.encode |> elem(1)
  end

  defp autocomplete_body(map) do
    Enum.into(map, %{}) |> Poison.encode |> elem(1)
  end

  defp ticket_url(id) do
    ExPrintf.sprintf(@ticket_with_id, [id])
  end

  defp headers do
    ["Content-Type": "application/json"]
  end

  defp parse_delete_ticket(response) do
    response
  end

  defp parse_collaborators(response) do
    Zendesk.User.from_json_array(response)
  end

  defp parse_related_tickets_info(response) do
    Zendesk.TicketRelated.from_json(response)
  end

  defp parse_job_status_ticket(response) do
    Zendesk.JobStatus.from_json(response)
  end

  defp parse_single_ticket(response) do
    Zendesk.Ticket.from_json(response)
  end

  defp parse_multiple_tickets(response) do
    Zendesk.Ticket.from_json_array(response)
  end

end
