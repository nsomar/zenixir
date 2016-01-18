defmodule BrandTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it gets all the brands" do
    use_cassette "all_brands" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> all_brands

      assert length(res) == 2
      assert res |> hd |> Dict.get(:name) == "BrandOne"
    end
  end

  test "it shows a brand" do
    use_cassette "show_brand" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> show_brand(brand_id: "26847")

      assert res.name == "BrandOne"
    end
  end

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
