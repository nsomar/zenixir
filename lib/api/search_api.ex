
defmodule Zendesk.SearchApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk searches
  """

  @endpoint "/search.json?query=%s"
  use Zendesk.CommonApi


  @doc """
  Get a list of all user fields

  `type` the type of the searches

  `query` query to perform
  """
  def search(account, type: type, query: query) do
    type_string = to_char_list(type)
    search(account, raw_query: "type:#{type_string} #{query}")
  end

  @doc """
  Get a list of all user fields

  `query` query to perform
  """
  def search(account, query: query) do
    search(account, raw_query: query)
  end

  def search(account, raw_query: raw_query) do
    perform_request(&parse_search/1,
    account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@endpoint, [raw_query]) |> URI.encode)
  end

  @doc """
  Get the next list of all user fields

  `url` : The full url
  """
  def next_url(account, url) do
    perform_request(&parse_search/1,
    account: account, verb: :get,
    endpoint: url)
  end

  # Private

  defp parse_search(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1)
  end

end
