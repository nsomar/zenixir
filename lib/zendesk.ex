defmodule Zendesk do
  @moduledoc """
  Main zendesk module.

  Example: `use Zendesk`
  """


  @doc """
  Create a zendeks account

  `domain` the account domain, example `https://domain.zendesk.com/api/v2`

  `email`: the zendesk email

  `password`: the zendesk password
  """
  def account(domain: domain, email: email, password: password) do
    %Zendesk.Account{domain: domain, email: email, password: password}
  end

  @doc """
  Create a zendeks account

  `subdomain` the account subdomain, example domain, this will be joined with https://{The_Sub_domain}.zendesk.com/api/v2

  `email`: the zendesk email

  `password`: the zendesk password
  """
  def account(subdomain: subdomain, email: email, password: password) do
    %Zendesk.Account{subdomain: subdomain, email: email, password: password}
  end

  @doc """
  Create a zendeks account

  `domain` the account domain, example `https://domain.zendesk.com/api/v2`

  `email`: the zendesk email

  `token`: the zendesk access token
  """
  def account(domain: domain, email: email, token: token) do
    %Zendesk.Account{domain: domain, email: email, token: token}
  end

  @doc """
  Create a zendeks account

  `subdomain` the account subdomain, example domain, this will be joined with https://{The_Sub_domain}.zendesk.com/api/v2

  `email`: the zendesk email

  `token`: the zendesk access token
  """
  def account(subdomain: subdomain, email: email, token: token) do
    %Zendesk.Account{subdomain: subdomain, email: email, token: token}
  end

  @doc """
  Create a zendeks account

  `subdomain` the account subdomain, example domain, this will be joined with https://{The_Sub_domain}.zendesk.com/api/v2

  `token`: the zendesk oauth token
  """
  def account(subdomain: subdomain, token: token) do
    %Zendesk.Account{subdomain: subdomain, token: token}
  end


  defmacro __using__(_) do
    quote do
      import Zendesk

      import Zendesk.UserApi
      import Zendesk.GroupApi
      import Zendesk.TicketApi
      import Zendesk.OrganizationApi
      import Zendesk.CommentApi
      import Zendesk.TicketFieldsApi
      import Zendesk.TicketMetricsApi
      import Zendesk.RequestApi
      import Zendesk.ViewApi
      import Zendesk.UserFieldsApi
      import Zendesk.GroupMembershipApi
      import Zendesk.AccountSettingsApi
      import Zendesk.AttachmentApi
      import Zendesk.BrandApi
      import Zendesk.TagsApi
      import Zendesk.SearchApi
      import Zendesk.TriggersApi
      import Zendesk.TargetsApi
      import Zendesk.AutomationsApi

      alias Zendesk.Account
      alias Zendesk.Client
      alias Zendesk.Ticket
      alias Zendesk.TicketField
      alias Zendesk.Request
      alias Zendesk.View
    end
  end

end
