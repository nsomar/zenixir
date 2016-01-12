defmodule LoginTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it returns authentication error if username password is incorrect" do
    use_cassette "users_error_auth" do
      res = Zendesk.account(url: "https://your_token.zendesk.com/api/v2", email: "a", password: "p")
      |> all_users
      
      assert res.error == "Couldn't authenticate you"
    end
  end


  test "it logins correctly with email and password" do
    use_cassette "users_email_pass_auth" do
      res = Zendesk.account(url: "https://your_token.zendesk.com/api/v2",
      email: "test@me.com", password: "test")
      |> all_users

      assert length(res) > 90
      assert (hd res).id == 2351783922
    end
  end


  test "it logins correctly with email and access token" do
    use_cassette "users_email_pass_auth" do
      res = Zendesk.account(url: "https://your_token.zendesk.com/api/v2",
      email: "test@me.com", token: "blabla")
      |> all_users

      assert length(res) > 90
      assert (hd res).id == 2351783922
    end
  end

end
