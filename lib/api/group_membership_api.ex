
defmodule Zendesk.GroupMembershipApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk user group membership
  """

  @endpoint "/group_memberships.json"
  @membership_for_user "/users/%s/group_memberships.json"
  @membership_for_group "/groups/%s/memberships.json"
  @group_membership_with_id "/group_memberships/%s.json"
  @group_membership_for_user_with_id "/users/%s/group_memberships/%s.json"

  use Zendesk.CommonApi


  @doc """
  Get a list of all group membership
  """
  def all_group_membership(account) do
    perform_request(&parse_all_membership/1, account: account, verb: :get, endpoint: @endpoint)
  end

  @doc """
  Get a list of all group membership

  `user_id` user id to get membership
  """
  def all_group_membership(account, user_id: user_id) do
    perform_request(&parse_all_membership/1, account: account, verb: :get,
     endpoint: ExPrintf.sprintf(@membership_for_user, [user_id]))
  end

  @doc """
  Get a list of all group membership

  `group_id` group id to get membership
  """
  def all_group_membership(account, group_id: group_id) do
    perform_request(&parse_all_membership/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@membership_for_group, [group_id]))
  end

  @doc """
  Get a group membership

  `membership_id` group membership id
  """
  def group_membership(account, membership_id: membership_id) do
    perform_request(&parse_single_membership/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@group_membership_with_id, [membership_id]))
  end

  @doc """
  Get a group membership for a user

  `membership_id` group membership id

  `user_id` the user id
  """
  def group_membership(account, membership_id: membership_id, user_id: user_id) do
    perform_request(&parse_single_membership/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@group_membership_for_user_with_id, [user_id, membership_id]))
  end

  # Private

  defp parse_all_membership(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1) |> Dict.get(:group_memberships)
  end

  defp parse_single_membership(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1) |> Dict.get(:group_membership)
  end

end
