defmodule GroupTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it gets the groups" do
    use_cassette "all_groups" do
      res = Zendesk.account(url: "https://your_token.zendesk.com/api/v2",
      email: "test@test.test", password: "test")
      |> all_groups

      assert res |> hd |> Map.get(:id) == 123123
      assert length(res) == 4
    end
  end

end
