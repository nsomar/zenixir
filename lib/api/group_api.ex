
defmodule Zendesk.GroupApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk groups
  """

  @endpoint "/groups.json"
  use Zendesk.CommonApi


  @doc """
  Get a list of all groups
  """
  def all_groups(account) do
    perform_request(&parse_get_groups/1, account: account, verb: :get, endpoint: @endpoint)
  end

  # Private

  defp parse_get_groups(response) do
    Zendesk.Group.from_json(response)
  end

end
