defmodule Zendesk.Account do
  @moduledoc """
  Zendesk Account module
  """

  defstruct [:email, :password, :subdomain, :domain, :token]


  @doc """
  Get the full url

  `account`: the zendesk account

  `endpoint`: the resource endpoint
  """
  def full_url(account, <<"https://">> <> rest = endpoint), do: URI.merge(domain(account), endpoint) |> to_string()
  def full_url(account, endpoint), do: domain(account) <> endpoint

  @doc """
  Get the account domain

  `subdomain`: the subdomain
  """
  def domain(%Zendesk.Account{subdomain: subdomain})
  when not is_nil subdomain  do
    "https://#{subdomain}.zendesk.com/api/v2"
  end

  @doc """
  Get the account domain

  `domain`: the domain
  """
  def domain(%Zendesk.Account{domain: domain})
  when not is_nil domain  do
    domain
  end

  @doc """
  Get the Auth for a Zendesk.Account

  `email`: the zendesk email

  `password`: the zendesk password
  """
  def auth(%Zendesk.Account{email: email, password: password})
  when not is_nil password  do
     [hackney: [basic_auth: {email, password}]]
  end


  @doc """
  Get the Auth for a Zendesk.Account

  `email`: the zendesk email

  `token`: the zendesk auth token
  """
  def auth(%Zendesk.Account{email: email, token: token})
  when not is_nil email do
     [hackney: [basic_auth: {email <> "/token", token}]]
  end

  @doc """
  Get the Auth for a Zendesk.Account

  `token`: zendesk oauth token
  """
  def auth(%Zendesk.Account{token: token})
  when not is_nil token do
    [{"Authorization", "Bearer #{token}"}]
  end
end
