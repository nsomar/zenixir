defmodule GroupTest do
  use ExUnit.Case, async: false
  use Zendesk
  use TestHelper
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney


  test "it gets the groups" do
    use_cassette "all_groups" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.test", password: "test")
      |> all_groups

      assert res |> hd |> Map.get(:id) == 123123
      assert length(res) == 4
    end
  end

  test "it gets a user groups" do
    use_cassette "user_groups" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> all_groups(user_id: "235179052")

      assert res |> hd |> Map.get(:id) == 21554407
      assert length(res) == 3
    end
  end

  test "it gets a group" do
    use_cassette "group_with_id" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> show_group(group_id: "21554407")

      assert res.id == 21554407
      assert res.name == "Another group"
    end
  end

end
