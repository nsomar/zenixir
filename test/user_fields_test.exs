defmodule UserFieldsTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it gets all user fields" do
    use_cassette "all_user_fields" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> all_user_fields

      assert length(res) == 1
      assert res |> hd |> Dict.get(:title) == "test2"
    end
  end

end
