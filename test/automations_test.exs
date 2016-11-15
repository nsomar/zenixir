defmodule AutomationsTest do
  use ExUnit.Case, async: false
  use Zendesk
  use TestHelper
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney


  test "it can create a bare ticket" do
    ticket = Zendesk.Ticket.new("Hello")
    assert ticket.comment.body == "Hello"
  end

 

  test "it can get a ticket with id" do
    use_cassette "get_ticket_with_id" do

    res = Zendesk.account(subdomain: "your_subdomain",
    email: "test@test.com", password: "test")
    |> show_ticket(ticket_id: "587")

    assert res |> Dict.get(:id) == 587
    assert res |> Dict.get(:subject) == "The subject"
    end
  end


  test "it can get multiple tickets" do
    use_cassette "many_tickets" do

      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.com", password: "test")
      |> show_tickets(ids: ["1", "587"])

      assert res |> hd |> Dict.get(:id) == 1
      assert length(res) == 2
    end
  end

end
