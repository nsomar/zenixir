
defmodule Zendesk.CommentApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk comments
  """

  @all_comments_for_ticket "/tickets/%s/comments.json"
  @redact_comment "/tickets/%s/comments/%s/redact.json"
  @make_private "/tickets/%s/comments/%s/make_private.json"

  @all_comments_for_request "/requests/%s/comments.json"
  @comment_for_request "/requests/%s/comments/%s.json"
  use Zendesk.CommonApi


  @doc """
  Get all the comments for a ticket

  `ticket_id` the ticket id
  """
  def all_comments(account, ticket_id: ticket_id) do
    perform_request(&parse_get_comments/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@all_comments_for_ticket, [ticket_id]))
  end

  @doc """
  Get all the comments for a ticket

  `ticket_id` the ticket id
  """
  def all_comments(account, request_id: request_id) do
    perform_request(&parse_get_comments/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@all_comments_for_request, [request_id]))
  end

  @doc """
  Get a comment for a request by id

  `request_id` the request id

  `comment_id` the comment id
  """
  def show_comment(account, request_id: request_id, comment_id: comment_id) do
    perform_request(&parse_get_comment/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@comment_for_request, [request_id, comment_id]))
  end

  @doc """
  Readact text in a comment

  `ticket_id` the ticket id
  """
  def redact_comment(account, ticket_id: ticket_id, comment_id: comment_id, text: text) do
    perform_request(&parse_get_comment/1, account: account,
    verb: :put,
    endpoint: ExPrintf.sprintf(@redact_comment, [ticket_id, comment_id]),
    body: redact_json(text),
    headers: headers)
  end

  @doc """
  Make a comment private

  `ticket_id` the ticket id
  """
  def make_comment_private(account, ticket_id: ticket_id, comment_id: comment_id) do
    perform_request(&parse_get_comment/1, account: account,
    verb: :put,
    endpoint: ExPrintf.sprintf(@make_private, [ticket_id, comment_id]))
  end

  # Private

  defp redact_json(text) do
    %{text: text} |> Poison.encode |> elem(1)
  end

  defp headers do
    ["Content-Type": "application/json"]
  end

  defp parse_get_comment(response) do
    Zendesk.Comment.from_json(response)
  end

  defp parse_get_comments(response) do
    Zendesk.Comment.from_json_array(response)
  end

end
