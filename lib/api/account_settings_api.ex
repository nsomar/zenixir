
defmodule Zendesk.AccountSettingsApi do
  @moduledoc """
  Module that contains fucntions to deal with Zendesk account settings
  """

  @endpoint "/account/settings.json"
  use Zendesk.CommonApi


  @doc """
  Get the account settings
  """
  def account_settings(account) do
    perform_request(&parse_account_settings/1, account: account, verb: :get, endpoint: @endpoint)
  end

  # Private

  defp parse_account_settings(response) do
    Poison.Parser.parse(response, keys: :atoms) |> elem(1) |> Dict.get(:settings)
  end

end
