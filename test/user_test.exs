defmodule LoginTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it returns authentication error if username password is incorrect" do
    use_cassette "users_error_auth" do
      res = Zendesk.account(subdomain: "your_subdomain", email: "a", password: "p")
      |> all_users

      assert res.error == "Couldn't authenticate you"
    end
  end


  test "it logins correctly with email and password" do
    use_cassette "users_email_pass_auth" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@me.com", password: "test")
      |> all_users

      assert length(res) > 90
      assert (hd res).id == 2351783922
    end
  end


  test "it logins correctly with email and access token" do
    use_cassette "users_email_pass_auth" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@me.com", token: "blabla")
      |> all_users

      assert length(res) > 90
      assert (hd res).id == 2351783922
    end
  end

  test "it gets users for group" do
    use_cassette "users_for_group" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> all_users(group_id: "21554407")

      assert length(res) == 5
      assert (hd res).id == 237065843
    end
  end

  test "it gets users for organizations" do
    use_cassette "users_for_organizations" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> all_users(organization_id: "22016037")

      assert length(res) == 1
      assert (hd res).id == 236084977
    end
  end

  test "it gets a user" do
    use_cassette "user_with_id" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> user_with_id(id: "235178392")

      assert res.id == 235178392
      assert res.name == "Light Agent #2"
    end
  end

  test "it gets many users" do
    use_cassette "users_with_ids" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> users_with_ids(ids: ["235178392", "235179052"])

      assert res |> length == 2
      assert res |> hd |> Map.get(:name) == "Light Agent #2"
    end
  end

  test "it searches users" do
    use_cassette "search_user" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> search_user(query: "Tags Agent")

      assert res |> length == 1
      assert res |> hd |> Map.get(:name) == "No Tags Agent"
    end
  end

  test "it autocomplete user by name" do
    use_cassette "autocomplete_user" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> autocomplete_user(name: "Tags Agent")

      assert res |> length == 1
      assert res |> hd |> Map.get(:name) == "No Tags Agent"
    end
  end

  test "it gets the current user" do
    use_cassette "current_user" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> current_user

      assert res.id == 236084977
      assert res.name == "Owner"
    end
  end

end
