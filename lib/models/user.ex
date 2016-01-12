defmodule Zendesk.User do
  @moduledoc """
  Zendesk User
  """


  defstruct [:id, :url, :name, :email, :created_at, :updated_at, :time_zone,
            :phone, :photo, :locale_id, :locale, :organization_id, :role, :verified,
            :external_id, :alias, :active, :shared, :shared_agent, :last_login_at, :two_factor_auth_enabled,
            :signature, :details, :notes, :custom_role_id, :moderator, :ticket_restriction, :only_private_comments,
            :restricted_agent, :suspended, :chat_only, :user_fields]


  @doc """
  Decode a JSON to a Map

  `json`: the json to parse
  """
  def from_json(json) do
    # Poison.decode!(json, as: %{"users" => [Zendesk.User]})["users"]
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:users)
  end

end
