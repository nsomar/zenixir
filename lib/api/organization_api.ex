
defmodule Zendesk.OrganizationApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk Organizations
  """

  @all_endpoint "/organizations.json"
  @show_organization "/organizations/%s.json"
  @oraganization_for_user "/users/%s/organizations.json"
  @autocomplete_organizations "/organizations/autocomplete.json?name=%s"

  use Zendesk.CommonApi


  @doc """
  Get all the organizations
  """
  def all_organizations(account) do
    perform_request(&parse_get_organizations/1, account: account, verb: :get, endpoint: @all_endpoint)
  end

  @doc """
  Get all the organizations

  `user_id` user id to get organizations for
  """
  def all_organizations(account, user_id: user_id) do
    perform_request(&parse_get_organizations/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@oraganization_for_user, [user_id]))
  end

  @doc """
  Autocomplete the Organizations

  `name` organization name
  """
  def autocomplete_organizations(account, name: name) do
    perform_request(&parse_get_organizations/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@autocomplete_organizations, [name]) |> URI.encode)
  end

  @doc """
  Show organization

  `organization_id` organization name
  """
  def show_organization(account, organization_id: oraganization_id) do
    perform_request(&parse_organization/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@show_organization, [oraganization_id]))
  end

  # Private

  defp parse_organization(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1) |> Dict.get(:organization)
  end

  defp parse_get_organizations(response) do
    Zendesk.Organization.from_json(response)
  end

end
