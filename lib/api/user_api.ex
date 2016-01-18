
defmodule Zendesk.UserApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk users
  """

  @endpoint "/users.json"
  @users_for_group "/groups/%s/users.json"
  @users_for_organizations "/organizations/%s/users.json"
  @user_with_id "/users/%s.json"
  @many_users "/users/show_many.json?ids=%s"
  @searches_users "/users/search.json?query=\"%s\""
  @autocomplete_users "/users/autocomplete.json?name=\"%s\""
  @current_user "/users/me.json"

  use Zendesk.CommonApi


  @doc """
  Get all the users
  """
  def all_users(account) do
    perform_request(&parse_get_users/1, account: account, verb: :get, endpoint: @endpoint)
  end

  @doc """
  Get user for group

  `group_id`: the group id
  """
  def all_users(account, group_id: group_id) do
    perform_request(&parse_get_users/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@users_for_group, [group_id]))
  end

  @doc """
  Get user for an organization

  `organization_id`: organization id
  """
  def all_users(account, organization_id: organization_id) do
    perform_request(&parse_get_users/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@users_for_organizations, [organization_id]))
  end

  @doc """
  Get a user with an id

  `id`: the user id
  """
  def user_with_id(account, id: id) do
    perform_request(&parse_get_user/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@user_with_id, [id]))
  end

  @doc """
  Get many users

  `ids`: the user ids
  """
  def users_with_ids(account, ids: ids) do
    ids_strings = Enum.join(ids, ",")
    perform_request(&parse_get_users/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@many_users, [ids_strings]))
  end

  @doc """
  Searches for users

  `query`: the query to use
  """
  def search_user(account, query: query) do
    perform_request(&parse_get_users/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@searches_users, [query]) |> URI.encode)
  end

  @doc """
  Autocomplete a user by name

  `name`: the user name
  """
  def autocomplete_user(account, name: name) do
    perform_request(&parse_get_users/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@autocomplete_users, [name]) |> URI.encode)
  end

  @doc """
  Current user

  `name`: the user name
  """
  def current_user(account) do
    perform_request(&parse_get_user/1, account: account, verb: :get,
    endpoint: @current_user)
  end

  # Private

  defp parse_get_users(response) do
    Zendesk.User.from_json_array(response)
  end

  defp parse_get_user(response) do
    Zendesk.User.from_json(response)
  end

end
