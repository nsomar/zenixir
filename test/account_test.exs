defmodule AccountTest do
  use ExUnit.Case, async: false
  use Zendesk
  use TestHelper
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney


  test "it gets the domain from the subdomain" do
    assert Zendesk.account(subdomain: "bla", email: "a@a.com", password: "123")
    |> Account.domain == "https://bla.zendesk.com/api/v2"
  end

  test "it gets the domain from the domain" do
    assert Zendesk.account(domain: "https://blabla.zendesk.com/api/v2", email: "a@a.com", password: "123")
    |> Account.domain == "https://blabla.zendesk.com/api/v2"
  end

end
