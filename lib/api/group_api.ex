
defmodule Zendesk.GroupApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk groups
  """

  @endpoint "/groups.json"
  @user_groups "/users/%s/groups.json"
  @group_with_id "/groups/%s.json"

  use Zendesk.CommonApi


  @doc """
  Get a list of all groups
  """
  def all_groups(account) do
    perform_request(&parse_get_groups/1, account: account, verb: :get, endpoint: @endpoint)
  end

  @doc """
  Get user groups

  `user_id` the user id
  """
  def user_groups(account, user_id: user_id) do
    perform_request(&parse_get_groups/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@user_groups, [user_id]))
  end

  @doc """
  Get group by id

  `id` the group id
  """
  def group_with_id(account, id: id) do
    perform_request(&parse_get_group/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@group_with_id, [id]))
  end

  # Private

  defp parse_get_groups(response) do
    Zendesk.Group.from_json_array(response)
  end

  defp parse_get_group(response) do
    Zendesk.Group.from_json(response)
  end

end
