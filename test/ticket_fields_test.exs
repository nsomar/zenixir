defmodule TicketFieldsTest do
  use ExUnit.Case, async: false
  use Zendesk
  use TestHelper
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney


  test "it can get all ticket fields" do
    use_cassette "all_ticket_fields" do
      res = Zendesk.account(subdomain: "your_subdomain", email: "test@test.com", password: "test")
      |> all_ticket_fields

      assert res |> length == 14
      assert res |> hd |> Map.get(:id) == 21400357
    end
  end

  test "it can get a ticket field" do
    use_cassette "single_ticket_field" do
      res = Zendesk.account(subdomain: "your_subdomain", email: "test@test.com", password: "test")
      |> all_ticket_fields(ticket_id: "21400357")

      assert res |> Map.get(:id) == 21400357
    end
  end

  test "it can create a ticket map" do
    field = TicketField.new(type: "text", title: "The title")
    assert field.type == "text"
    assert field.title == "The title"
  end

  test "it catches bad ticket types" do
    assert_raise RuntimeError, "Wrong type passed", fn ->
      TicketField.new(type: "wrong_one", title: "The title")
    end
  end

  test "it can add ticket field options" do
    field = TicketField.new(type: "text", title: "The title")
    |> TicketField.add_custom_field_option(name: "option1", value: "value1")
    |> TicketField.add_custom_field_option(name: "option2", value: "value2")

    assert field.custom_field_options |> length == 2
    assert field.custom_field_options |> hd |> Dict.get(:name) == "option1"
  end

  test "it can create a ticket field" do
    use_cassette "create_ticket_field" do
      field = TicketField.new(type: "tagger", title: "The title")
      |> TicketField.add_custom_field_option(name: "Option 1", value: "value1")
      |> TicketField.add_custom_field_option(name: "Option 2", value: "value2")

      res = Zendesk.account(subdomain: "your_subdomain", email: "test@test.com", password: "test")
      |> create_ticket_field(ticket_field: field)

      assert res |> Map.get(:id) == 29904308
      assert res |> Map.get(:title) == "Age"

      assert res.custom_field_options |> length == 2
      assert res.custom_field_options |> hd |> Dict.get(:name) == "Option 1"
    end
  end

  test "it can delete a ticket field" do
    use_cassette "update_ticket_field" do
      field = TicketField.new(type: "text", title: "The title")
      res = Zendesk.account(subdomain: "your_subdomain", email: "test@test.com", password: "test")
      |> update_ticket_field(field_id: "29901588", ticket_field: field)

      assert res["ticket_field"] |> Map.get("id") == 29901588
      assert res["ticket_field"] |> Map.get("title") == "The title"
    end
  end

  test "it can delete a ticket field with id" do
    use_cassette "delete_ticket_field" do
      res = Zendesk.account(subdomain: "your_subdomain", email: "test@test.com", password: "test")
      |> delete_ticket_field(field_id: "29901588")

      assert res == :ok
    end
  end

end
