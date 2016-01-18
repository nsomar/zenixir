defmodule AccountSettingsTests do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it gets the account settings" do
    use_cassette "account_settings" do
      res = Zendesk.account(domain: "https://your_subdomain.zendesk.com/api/v2",
      email: "test@zendesk.com", password: "test")
      |> account_settings

      assert res.apps.use == true
      assert res.tickets.collaboration == true
    end
  end

end
