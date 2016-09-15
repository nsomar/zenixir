defmodule ClientTest do
  use ExUnit.Case, async: false
  use Zendesk
  use TestHelper
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney


  test "it performs a client request" do
    use_cassette "client_request_memership" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> Client.request(resource: "organization_memberships.json")

      assert length(res.organization_memberships) == 1
      assert res.organization_memberships |> hd |> Dict.get(:user_id) == 236084977
    end
  end

  test "it can do a post request with body" do
    use_cassette "set_tags_for_ticket" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> Client.request(resource: "tickets/1/tags.json",
      verb: :post,
      body: %{tags: ["1", "2"]})

      assert length(res.tags) == 2
      assert res.tags == ["1", "2"]
    end
  end

  test "it can do a post request with json" do
    use_cassette "set_tags_for_ticket" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> Client.request(resource: "tickets/1/tags.json",
      verb: :post,
      json: Poison.encode!(%{tags: ["1", "2"]}) )

      assert length(res.tags) == 2
      assert res.tags == ["1", "2"]
    end
  end

  test "it prepares a correct resource" do
    assert Client.prepare_resource("a_resourece.json") == "/a_resourece.json"
    assert Client.prepare_resource("/a_resourece.json") == "/a_resourece.json"
  end

end
