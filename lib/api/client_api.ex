
defmodule Zendesk.Client do
  @moduledoc """
  Module that performs custom api requests
  """

  use Zendesk.CommonApi


  @doc """
  Perform an http request

  `account` the zendesk account

  `verb` the http verb

  `resource` the resource api to hit

  `headers` the headers to send

  `body` the map to send, will be encoded to json
  """
  def request(account, verb: verb, resource: resource, headers: headers, body: body) do
    request(account, verb: verb, resource: resource,
    headers: headers, json: Poison.encode!(body))
  end

  @doc """
  Perform an http request

  `account` the zendesk account

  `verb` the http verb

  `resource` the resource api to hit

  `json` the json object to send
  """
  def request(account, resource: resource, verb: verb, json: json) do
    perform_request(&parse/1,
    account: account,
    verb: verb,
    endpoint: resource |> prepare_resource,
    body: json,
    headers: ["Content-Type": "application/json"])
  end

  @doc """
  Perform an http request

  `account` the zendesk account

  `verb` the http verb

  `resource` the resource api to hit

  `headers` the headers to send

  `json` the json object to send
  """
  def request(account, verb: verb, resource: resource, headers: headers, json: json) do
    perform_request(&parse/1,
    account: account,
    verb: verb,
    endpoint: resource |> prepare_resource,
    body: json,
    headers: headers)
  end

  @doc """
  Perform an http request

  `account` the zendesk account

  `params` the params passed

  Params can contain:

  `verb` the http verb

  `resource` the resource api to hit

  `headers` the headers to send

  `body` the map to send, will be encoded to json
  """
  def request(account, params) do
    request(account,
    verb: params[:verb] || :get,
    resource: params[:resource],
    headers: params[:headers] || ["Content-Type": "application/json"],
    body: params[:body] || nil)
  end

  def prepare_resource("/" <> endpoint) do
    "/#{endpoint}"
  end

  def prepare_resource(endpoint) do
    "/#{endpoint}"
  end

  # Private

  defp parse(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1)
  end

end
