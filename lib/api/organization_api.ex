
defmodule Zendesk.OrganizationApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk Organizations
  """

  @all_endpoint "/organizations.json"

  use Zendesk.CommonApi


  @doc """
  Get all the organizations
  """
  def all_organizations(account) do
    perform_request(&parse_get_organizations/1, account: account, verb: :get, endpoint: @all_endpoint)
  end


  # Private

  defp parse_get_organizations(response) do
    Zendesk.Organization.from_json(response)
  end

end
