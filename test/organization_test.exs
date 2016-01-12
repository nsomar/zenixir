defmodule OrganizationTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it gets all the organizations" do
    use_cassette "all_organizations" do
      res = Zendesk.account(url: "https://your_token.zendesk.com/api/v2",
      email: "test@test.test", password: "test")
      |> all_organizations

      assert length(res) == 2
      assert res |> hd |> Dict.get(:name) == "[TEST] Mobile - Enterprise - Testing - Z3N"
    end
  end

end
