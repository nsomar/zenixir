
defmodule Zendesk.RequestApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk requests
  """

  @endpoint "/requests.json"
  @request_status "/requests.json?%s"
  @request_for_user "/users/%s/requests.json"
  @request_for_organization "/organizations/%s/requests.json"
  @search_requests "/requests/search.json?query=\"%s\""
  @single_request "/requests/%s.json"
  use Zendesk.CommonApi


  @doc """
  Get all the requests
  """
  def all_requests(account) do
    perform_request(&parse_requests/1, account: account, verb: :get, endpoint: @endpoint)
  end

  @doc """
  Get requests with multiple statues
  """
  def request_with_statuses(account, statuses: statuses) do
    st = Enum.join(statuses, ",")
    perform_request(&parse_requests/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@request_status, [st]))
  end

  @doc """
  Get requests for a user
  """
  def requests_for_user(account, user_id: user_id) do
    perform_request(&parse_requests/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@request_for_user, [user_id]))
  end

  @doc """
  Get requests for an organization
  """
  def requests_for_organization(account, organization_id: organization_id) do
    perform_request(&parse_requests/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@request_for_organization, [organization_id]))
  end

  @doc """
  Searches for a request
  """
  def search_requests(account, query: query) do
    perform_request(&parse_requests/1, account: account, verb: :get,
    endpoint: URI.encode(ExPrintf.sprintf(@search_requests, [query])))
  end

  @doc """
  Gets a request
  """
  def request_with_id(account, id: request_id) do
    perform_request(&parse_request/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@single_request, [request_id]))
  end

  @doc """
  Create a request
  """
  def create_request(account, request: request) do
    json = Zendesk.Request.to_json(%{request: request})
    perform_request(&parse_request/1, account: account, verb: :post, endpoint: @endpoint,
    body: json, headers: headers)
  end

  @doc """
  Update a request
  """
  def update_request(account, id: id, request: request) do
    json = Zendesk.Request.to_json(%{request: request})
    perform_request(&parse_request/1, account: account, verb: :put,
    endpoint: ExPrintf.sprintf(@single_request, [id]),
    body: json, headers: headers)
  end

  # Private

  defp headers do
    ["Content-Type": "application/json"]
  end

  defp parse_request(response) do
    Zendesk.Request.from_json(response)
  end

  defp parse_requests(response) do
    Zendesk.Request.from_json_array(response)
  end

end
