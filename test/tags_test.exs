defmodule TagTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it gets all tags" do
    use_cassette "all_tags" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> all_tags

      assert length(res) == 52
      assert res |> hd |> Dict.get(:name) == "tag_one"
    end
  end

  test "it gets all tags for a ticket" do
    use_cassette "all_tags_for_ticket" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> all_tags(ticket_id: "1")

      assert length(res) == 6
      assert res |> hd == "sample"
    end
  end

  test "it gets all tags for a user" do
    use_cassette "all_tags_for_user" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> all_tags(user_id: "3812099768")

      assert length(res) == 1
      assert res |> hd == "asd"
    end
  end

  test "it sets a ticket tags" do
    use_cassette "set_tags_for_ticket" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> set_tags(ticket_id: "1", tags: ["1", "2"])

      assert length(res) == 2
      assert res |> hd == "1"
    end
  end

  test "it update a ticket tags" do
    use_cassette "update_tags_for_ticket" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> update_tags(ticket_id: "1", tags: ["3", "4"])

      assert length(res) == 4
      assert "2" in res
    end
  end

  test "it sets a user tags" do
    use_cassette "set_tags_for_user" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> set_tags(user_id: "453222636", tags: ["1", "2"])

      assert length(res) == 2
      assert res |> hd == "1"
    end
  end

  test "it update a user tags" do
    use_cassette "update_tags_for_user" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> update_tags(user_id: "453222636", tags: ["3", "4"])

      assert length(res) == 4
      assert "2" in res
    end
  end

  test "it delete a user tags" do
    use_cassette "delete_tags_for_user" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> delete_tags(user_id: "453222636", tags: ["3", "4"])

      assert length(res) == 2
      assert "2" in res
    end
  end

  test "it delete a ticket tags" do
    use_cassette "delete_tags_for_ticket" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> delete_tags(ticket_id: "1", tags: ["3", "4"])

      assert length(res) == 2
      assert "2" in res
    end
  end

end
