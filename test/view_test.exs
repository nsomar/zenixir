defmodule ViewTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it gets all the views" do
    use_cassette "all_views" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> all_views

      assert length(res) == 11
      assert res |> hd |> Dict.get(:id) == 29292517
    end
  end

  test "it gets the active views" do
    use_cassette "active_views" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> active_views

      assert length(res) == 9
      assert res |> hd |> Dict.get(:id) == 29292517
    end
  end

  test "it gets the compact views" do
    use_cassette "compact_views" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> compact_views

      assert length(res) == 9
      assert res |> hd |> Dict.get(:id) == 29292517
    end
  end

  test "it get a view" do
    use_cassette "view_with_id" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> show_view(view_id: "29292517")

      assert res.id == 29292517
      assert res.title == "Roger Wilco"
    end
  end

  test "it creats a view model" do
    view = View.new(title: "The Title")

    assert view.title == "The Title"
  end

  test "it can add a condition" do
    view = View.new(title: "The Title")
    |> View.add_condition(type: :any, field: "Field1", operator: "Op", value: "Value1")

    assert view.title == "The Title"
    assert view.any |> length == 1

    view = view |> View.add_condition(type: :any, field: "Field2", operator: "Op", value: "Value2")
    assert view.any |> length == 2

    view = View.new(title: "The Title")
    |> View.add_condition(type: :all, field: "Field1", operator: "Op", value: "Value1")

    assert view.title == "The Title"
    assert view.all |> length == 1

    view = view |> View.add_condition(type: :all, field: "Field2", operator: "Op", value: "Value2")
    assert view.all |> length == 2
  end

  test "it catches wrong conditions" do
    assert_raise RuntimeError, "Wrong condition type passed \"any222\"", fn ->
      View.new(title: "The Title")
      |> View.add_condition(type: :any222, field: "Field1", operator: "Op", value: "Value1")
    end
  end

  test "it sets the output columns" do
    view = View.new(title: "The Title")
    |> View.set_columns(["status", "description"])

    assert view.title == "The Title"
    assert view.output.columns |> Enum.at(0) == "status"
  end

  test "it creats a view" do
    use_cassette "create_view" do
      view = View.new(title: "The Title")
      |> View.add_condition(type: :any, field: "status", operator: "is", value: "open")

      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> create_view(view)

      assert res.id == 73599027
      assert res.title == "My unsolved tickets"
    end
  end

  test "it updates a view" do
    use_cassette "update_view" do
      view = View.new(title: "Another title")

      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> update_view(view_id: "29292517", view: view)

      assert res.title == "Another title"
    end
  end

  test "it deletes a view" do
    use_cassette "delete_view" do

      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> delete_view(view_id: "73606987")

      assert res == :ok
    end
  end

  test "it executes a view" do
    use_cassette "execute_view" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> execute_view(view_id: "73607107")

      assert res |> length == 14
      assert res |> Enum.at(0) |> Map.get(:requester_id) == 236084977
    end
  end

  test "it creates a view" do
    use_cassette "view_tickets" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> view_tickets(view_id: "73607107")

      assert res |> length == 14
      assert res |> Enum.at(0) |> Map.get(:requester_id) == 236084977
    end
  end

  test "it count the views" do
    use_cassette "count_views" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> count_views(ids: ["29292557", "73607107"])

      assert res |> length == 2
      assert res |> Enum.at(0) |> Map.get(:pretty) == "298"
    end
  end

  test "it count a view" do
    use_cassette "count_view" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> count_view(view_id: "29292557")

      assert res.fresh == true
      assert res.pretty == "298"
    end
  end

  test "it previews a view" do
    use_cassette "preview_view" do
      view = View.new(title: "The Title")
      |> View.add_condition(type: :all, field: "status", operator: "is", value: "open")

      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> preview_view(view)

      assert res |> length  == 14
    end
  end

  test "it counts a view preview" do
    use_cassette "count_view_preview" do
      view = View.new(title: "The Title")
      |> View.add_condition(type: :all, field: "status", operator: "is", value: "open")

      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> count_view_preview(view)

      assert res.fresh == true
      assert res.pretty == "14"
    end
  end

end
