defmodule Zendesk.Account do
  @moduledoc """
  Zendesk Account module
  """

  defstruct [:email, :password, :url, :token]


  @doc """
  Get the Auth for a Zendesk.Account

  `email`: the zendesk email

  `password`: the zendesk password
  """
  def auth(%Zendesk.Account{email: email, password: password})
  when not is_nil password  do
     [basic_auth: {email, password}]
  end


  @doc """
  Get the Auth for a Zendesk.Account

  `email`: the zendesk email

  `token`: the zendesk auth token
  """
  def auth(%Zendesk.Account{email: email, token: token})
  when not is_nil token != nil do
     [basic_auth: {email <> "/token", token}]
  end

end
