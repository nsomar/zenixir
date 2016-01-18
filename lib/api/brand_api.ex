
defmodule Zendesk.BrandApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk brands
  """

  @endpoint "/brands.json"
  @show_brand "/brands/%s.json"

  use Zendesk.CommonApi


  @doc """
  Get a list of all brands
  """
  def all_brands(account) do
    perform_request(&prase_brands/1, account: account, verb: :get, endpoint: @endpoint)
  end

  @doc """
  Show a brand

  `brand_id` the brand id
  """
  def show_brand(account, brand_id: brand_id) do
    perform_request(&prase_brand/1, account: account, verb: :get,
    endpoint: ExPrintf.sprintf(@show_brand, [brand_id]))
  end

  # Private

  defp prase_brands(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1) |> Dict.get(:brands)
  end

  defp prase_brand(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1) |> Dict.get(:brand)
  end

end
