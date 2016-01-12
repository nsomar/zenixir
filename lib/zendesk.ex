defmodule Zendesk do
  @moduledoc """
  Main zendesk module.

  Example: `use Zendesk`
  """


  @doc """
  Create a zendeks account

  `email`: the zendesk email

  `password`: the zendesk password
  """
  def account(url: url, email: email, password: password) do
    %Zendesk.Account{url: url, email: email, password: password}
  end


  @doc """
  Create a zendeks account

  `email`: the zendesk email

  `token`: the zendesk auth token
  """
  def account(url: url, email: email, token: token) do
    %Zendesk.Account{url: url, email: email, token: token}
  end


  defmacro __using__(_) do
    quote do
      import Zendesk

      import Zendesk.UserApi
      import Zendesk.GroupApi
      import Zendesk.TicketApi
      import Zendesk.OrganizationApi

      alias Zendesk.Ticket
    end
  end

end
