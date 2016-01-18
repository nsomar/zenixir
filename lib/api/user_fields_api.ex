
defmodule Zendesk.UserFieldsApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk user fields
  """

  @endpoint "/user_fields.json"
  use Zendesk.CommonApi


  @doc """
  Get a list of all user fields
  """
  def all_user_fields(account) do
    perform_request(&parse_user_fields/1, account: account, verb: :get, endpoint: @endpoint)
  end

  # Private

  defp parse_user_fields(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1) |> Dict.get(:user_fields)
  end

end
