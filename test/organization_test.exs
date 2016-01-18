defmodule OrganizationTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it gets all the organizations" do
    use_cassette "all_organizations" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.test", password: "test")
      |> all_organizations

      assert length(res) == 2
      assert res |> hd |> Dict.get(:name) == "[TEST] Mobile - Enterprise - Testing - Z3N"
    end
  end

  test "it gets all the organizations for a user" do
    use_cassette "all_organizations_for_user" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> all_organizations(user_id: "236084977")

      assert length(res) == 1
      assert res |> hd |> Dict.get(:name) == "Mobile - Enterprise - Testing - Z3N"
    end
  end

  test "it autocomplete organization name" do
    use_cassette "autocomplete_organizations" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> autocomplete_organizations(name: "test")

      assert length(res) == 1
      assert res |> hd |> Dict.get(:name) == "Mobile - Enterprise - Testing - Z3N"
    end
  end

  test "it shows an organization" do
    use_cassette "show_organization" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> show_organization(organization_id: "22016037")

      assert res.name == "Mobile - Enterprise - Testing - Z3N"
    end
  end

end
