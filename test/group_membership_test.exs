defmodule GroupMEmbershipTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it gets all the group membership" do
    use_cassette "all_group_membership" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.test", password: "test")
      |> all_group_membership

      assert length(res) == 30
      assert res |> hd |> Dict.get(:group_id) == 20305157
    end
  end

  test "it gets all the group membership for a user" do
    use_cassette "all_group_membership_for_user" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> all_group_membership(user_id: "237064573")

      assert length(res) == 3
      assert res |> hd |> Dict.get(:group_id) == 20305157
    end
  end

  test "it gets all the group membership for a group" do
    use_cassette "all_group_membership_for_group" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> all_group_membership(group_id: "21554407")

      assert length(res) == 5
      assert res |> hd |> Dict.get(:group_id) == 21554407
    end
  end

  test "it gets a group membership with id" do
    use_cassette "group_membership" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> show_group_membership(membership_id: "20967233")

      assert res.id == 20967233
    end
  end

  test "it gets a group membership with id for a user" do
    use_cassette "group_membership_for_user" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> show_group_membership(membership_id: "20967233", user_id: "237064573")

      assert res.id == 20967233
    end
  end

end
