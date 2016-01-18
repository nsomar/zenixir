
defmodule Zendesk.TagsApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk tags
  """

  @endpoint "/tags.json"
  @tags_for_ticket "/tickets/%s/tags.json"
  @tags_for_user "/users/%s/tags.json"

  use Zendesk.CommonApi


  @doc """
  Get a list of all tags
  """
  def all_tags(account) do
    perform_request(&parse_tags/1, account: account, verb: :get, endpoint: @endpoint)
  end

  @doc """
  Get a list of all tags

  `ticket_id` ticket id to get tags for
  """
  def all_tags(account, ticket_id: ticket_id) do
    perform_request(&parse_tags/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@tags_for_ticket, [ticket_id]))
  end

  @doc """
  Get a list of all tags

  `user_id` user id to get tags for
  """
  def all_tags(account, user_id: user_id) do
    perform_request(&parse_tags/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@tags_for_user, [user_id]))
  end

  @doc """
  Set a ticket tags

  `ticket_id` ticket id to set tags for

  `tags` tags to set
  """
  def set_tags(account, ticket_id: ticket_id, tags: tags) do
    perform_tag_request(account, verb: :post,
    endpoint: @tags_for_ticket, id: ticket_id, tags: tags)
  end

  @doc """
  Set a user tags

  `user_id` user id to set tags for

  `tags` tags to set
  """
  def set_tags(account, user_id: user_id, tags: tags) do
    perform_tag_request(account, verb: :post,
    endpoint: @tags_for_user, id: user_id, tags: tags)
  end

  @doc """
  Updates a ticket tags

  `ticket_id` ticket id to set tags for

  `tags` tags to update
  """
  def update_tags(account, ticket_id: ticket_id, tags: tags) do
    perform_tag_request(account, verb: :put,
    endpoint: @tags_for_ticket, id: ticket_id, tags: tags)
  end

  @doc """
  Updates a user tags

  `user_id` ticket id to set tags for

  `tags` tags to update
  """
  def update_tags(account, user_id: user_id, tags: tags) do
    perform_tag_request(account, verb: :put,
    endpoint: @tags_for_user, id: user_id, tags: tags)
  end

  @doc """
  Delete a ticket tags

  `ticket_id` ticket id to set tags for

  `tags` tags to delete
  """
  def delete_tags(account, ticket_id: ticket_id, tags: tags) do
    perform_tag_request(account, verb: :delete,
    endpoint: @tags_for_ticket, id: ticket_id, tags: tags)
  end
  
  @doc """
  Delete user tags

  `user_id` user id to set tags for

  `tags` tags to delete
  """
  def delete_tags(account, user_id: user_id, tags: tags) do
    perform_tag_request(account, verb: :delete,
    endpoint: @tags_for_user, id: user_id, tags: tags)
  end


  def perform_tag_request(account, verb: verb, endpoint: endpoint, id: id, tags: tags) do
    perform_request(&parse_tags/1,
    account: account,
    verb: verb,
    endpoint: ExPrintf.sprintf(endpoint, [id]),
    headers: headers,
    body: tags |> list_to_json(:tags))
  end


  # Private

  defp headers, do: ["Content-Type": "application/json"]

  defp list_to_json(list, key) do
    Poison.encode!(Map.put(%{}, key, list))
  end

  defp parse_tags(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1) |> Dict.get(:tags)
  end

end
