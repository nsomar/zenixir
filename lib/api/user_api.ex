
defmodule Zendesk.UserApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk users
  """

  @endpoint "/users.json"
  use Zendesk.CommonApi


  @doc """
  Get all the users
  """
  def all_users(account) do
    perform_request(&parse_get_users/1, account: account, verb: :get, endpoint: @endpoint)
  end

  # Private

  defp parse_get_users(response) do
    Zendesk.User.from_json(response)
  end

end
