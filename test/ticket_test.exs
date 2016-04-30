defmodule TicketTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it can create a bare ticket" do
    ticket = Zendesk.Ticket.new("Hello")
    assert ticket.comment.body == "Hello"
  end

  test "it can create a ticket with subject" do
    ticket = Ticket.new("Hello") |> Ticket.set_subject("The subject")

    assert ticket.comment.body == "Hello"
    assert ticket.subject == "The subject"
  end

  test "it can create a ticket and set the requestor" do
    ticket = Ticket.new("Hello") |> Ticket.add_requester(email: "test@test.net")

    assert ticket.comment.body == "Hello"
    assert ticket.requester == %{email: "test@test.net", name: "test@test.net"}
  end

  test "it can create a ticket with requeser_id" do
    ticket = Ticket.new("Hello") |> Ticket.set_requester_id("123")

    assert ticket.comment.body == "Hello"
    assert ticket.requester_id == "123"
  end

  test "it can create a ticket with assignee_id and assignee_email" do
    ticket = Ticket.new("Hello")
    |> Ticket.set_assignee_id("123")
    |> Ticket.set_assignee_email("asd@asd.asd")

    assert ticket.comment.body == "Hello"
    assert ticket.assignee_id == "123"
    assert ticket.assignee_email == "asd@asd.asd"
  end

  test "it can create a ticket with group_id" do
    ticket = Ticket.new("Hello") |> Ticket.set_group_id("123")

    assert ticket.group_id == "123"
  end

  test "it can create a ticket with collaborator_ids" do
    ticket = Ticket.new("Hello") |> Ticket.set_collaborator_ids(["1", "2", "3"])

    assert ticket.collaborator_ids == ["1", "2", "3"]
  end

  test "it can create a ticket with tags" do
    ticket = Ticket.new("Hello") |> Ticket.set_tags(["1", "2", "3"])

    assert ticket.tags == ["1", "2", "3"]
  end

  test "it can create a ticket with problem_id due_at, updated_stamp and safe_update" do
    ticket = Ticket.new("Hello")
    |> Ticket.set_problem_id("1")
    |> Ticket.set_due_at("2")
    |> Ticket.set_safe_update(true)
    |> Ticket.set_updated_stamp("3")

    assert ticket.problem_id == "1"
    assert ticket.due_at == "2"
    assert ticket.updated_stamp == "3"
    assert ticket.safe_update == true
  end

  test "it can create a ticket with external_id forum_topic_id" do
    ticket = Ticket.new("Hello")
    |> Ticket.set_external_id("222")
    |> Ticket.set_forum_topic_id("123")

    assert ticket.external_id == "222"
    assert ticket.forum_topic_id == "123"
  end

  test "it can create a ticket with assignee_email" do
    ticket = Ticket.new("Hello") |> Ticket.set_assignee_email("asd@asd.asd")

    assert ticket.comment.body == "Hello"
    assert ticket.assignee_email == "asd@asd.asd"
  end

  test "it can create a ticket with priority" do
    ticket = Ticket.new("Hello") |> Ticket.set_priority("urgent")

    assert ticket.comment.body == "Hello"
    assert ticket.priority == "urgent"
  end

  test "it can create a ticket with via_followup_source_id" do
    ticket = Ticket.new("Hello") |> Ticket.set_via_followup_source_id("123")

    assert ticket.comment.body == "Hello"
    assert ticket.via_followup_source_id == "123"
  end

  test "it catches wrong priorities" do
    assert_raise RuntimeError, "Wrong priority passed", fn ->
      Ticket.new("Hello") |> Ticket.set_priority("not_a_priority")
    end
  end

  test "it can create a ticket with type" do
    ticket = Ticket.new("Hello") |> Ticket.set_type("incident")

    assert ticket.comment.body == "Hello"
    assert ticket.type == "incident"
  end

  test "it catches wrong type" do
    assert_raise RuntimeError, "Wrong type passed", fn ->
      Ticket.new("Hello") |> Ticket.set_type("not_a_type")
    end
  end

  test "it can create a ticket collaborators" do
    ticket = Ticket.new("Hello") |> Ticket.add_collaborator(name: "Test", email: "t@t.com")
    assert ticket.collaborators |> length == 1

    ticket = ticket |> Ticket.add_collaborator(name: "Test1", email: "t1@t.com")
    assert ticket.collaborators |> length == 2

    assert ticket.collaborators |> Enum.at(0) |> Dict.get(:name) == "Test"
    assert ticket.collaborators |> Enum.at(1) |> Dict.get(:name) == "Test1"

    ticket = ticket |> Ticket.add_collaborator(id: "12345")
    assert ticket.collaborators |> length == 3

    assert ticket.collaborators |> Enum.at(2) == "12345"

    ticket = ticket |> Ticket.add_collaborator(email: "test@test.com")
    assert ticket.collaborators |> length == 4

    assert ticket.collaborators |> Enum.at(3) == "test@test.com"
  end

  test "it can create a custom fields" do
    ticket = Ticket.new("Hello") |> Ticket.add_custom_fields("1", "Value1")
    assert ticket.custom_fields |> length == 1

    ticket = ticket |> Ticket.add_custom_fields("2", "Value2")
    assert ticket.custom_fields |> length == 2

    assert ticket.custom_fields |> Enum.at(0) |> Dict.get(:value) == "Value1"
    assert ticket.custom_fields |> Enum.at(1) |> Dict.get(:value) == "Value2"
    # assert ticket.status == "open"
  end

  test "it can create a ticket with status" do
    ticket = Ticket.new("Hello") |> Ticket.set_status("open")

    assert ticket.comment.body == "Hello"
    assert ticket.status == "open"
  end

  test "it catches wrong status" do
    assert_raise RuntimeError, "Wrong status passed", fn ->
      Ticket.new("Hello") |> Ticket.set_status("not_a_status")
    end
  end

  test "it creates a json ticket" do
    ticket = Ticket.new("1222")

    Ticket.to_json(ticket)
  end


  test "it can create a ticket" do
    use_cassette "create_ticket" do
      ticket = Ticket.new("Test Ticket")
      |> Ticket.set_priority("urgent")
      |> Ticket.set_type("problem")
      |> Ticket.set_subject("The subject")

      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.test", password: "test")
      |> create_ticket(ticket: ticket)

      assert res.subject == "The subject"
    end
  end


  test "it can create a delete a ticket" do
    use_cassette "delete_tocket" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.test", password: "test")
      |> delete_ticket(ticket_id: "399")

      assert res == :ok
    end
  end


  test "it can get tickets collaborators" do
    use_cassette "ticket_collaborators" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.test", password: "test")
      |> ticket_collaborators(ticket_id: "603")

      assert res |> hd |> Map.get(:name) == "Someone"
    end
  end


  test "it can get tickets incidents" do
    use_cassette "ticket_incidents" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.test", password: "test")
      |> ticket_incidents(ticket_id: "502")

      assert length(res) == 100
    end
  end


  test "it can get ticket problems" do
    use_cassette "all_problems" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.test", password: "test")
      |> ticket_problems

      assert length(res) == 6
    end
  end


  test "it can autocomplete problems" do
    use_cassette "autocomplete_problems" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.test", password: "test")
      |> autocomplete_problems(text: "Subject")

      assert length(res) == 2
    end
  end


  test "it can update a ticket a ticket" do
    use_cassette "update_a_ticket" do
      ticket = Ticket.new("Test Ticket")
      |> Ticket.set_priority("urgent")
      |> Ticket.set_type("problem")
      |> Ticket.set_subject("Another subject")

      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.test", password: "test")
      |> update_ticket(ticket: ticket, ticket_id: "595")

      assert res.subject == "Another subject"
    end
  end


  test "it can merge two tickets" do
    use_cassette "merge_tickets" do

      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.test", password: "test")
      |> merge_tickets(target_id: "361", ids: ["344", "339"],
                       target_comment: "Closing this", source_comment: "Combing stuff")

      assert res.status == "queued"
      assert res.id == "f689a5f55bf847d6d6270be85d2489bf"
    end
  end


  test "it can mergeget ticket related" do
    use_cassette "ticket_related" do

      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.test", password: "test")
      |> ticket_related(ticket_id: "23")

      assert res.from_archive == false
      assert res.incidents == 0
    end
  end


    test "it can fetch all tickets" do
      use_cassette "all_tickets" do
        res = Zendesk.account(subdomain: "your_subdomain",
        email: "email@me.com", token: "jt82RfMETyIBzCBQwNuLeCh4YxdAps8rJeN99SW2")
        |> all_tickets

        assert length(res) == 100
        assert res |> hd |> Dict.get(:id) == 1
      end
    end


    test "it can fetch recent tickets" do
      use_cassette "recent_tickets" do
        res = Zendesk.account(subdomain: "your_subdomain",
        email: "email@me.com", token: "jt82RfMETyIBzCBQwNuLeCh4YxdAps8rJeN99SW2")
        |> recent_tickets

        assert res |> hd |> Dict.get(:raw_subject) == "The subject2"
        assert length(res) == 5
      end
    end


    test "it can fetch ticket all ticket for a requester" do
      use_cassette "requester_tickets" do
        res = Zendesk.account(subdomain: "your_subdomain",
          email: "email@me.com", token: "jt82RfMETyIBzCBQwNuLeCh4YxdAps8rJeN99SW2")
        |> show_ticket(requester_id: "4047329778")

        assert res |> hd |> Dict.get(:raw_subject) == "The subject"
        assert length(res) == 18
      end
    end


    test "it can fetch ticket assigned to a user" do
      use_cassette "assigned_tickets" do
        res = Zendesk.account(subdomain: "your_subdomain",
          email: "email@me.com", token: "jt82RfMETyIBzCBQwNuLeCh4YxdAps8rJeN99SW2")
        |> show_ticket(assignee_id: "236084977")

        assert res |> hd |> Dict.get(:raw_subject) == "Yiuiib"
        assert length(res) == 4
      end
    end


    test "it can fetch ticket cc'd to a user" do
      use_cassette "ccd_tickets" do
        res = Zendesk.account(subdomain: "your_subdomain",
          email: "email@me.com", token: "jt82RfMETyIBzCBQwNuLeCh4YxdAps8rJeN99SW2")
        |> show_ticket(cc_id: "236084977")

        assert res |> hd |> Dict.get(:raw_subject) == "Yiuiib"
        assert length(res) == 1
      end
    end


    test "it can fetch ticket for an organization" do
      use_cassette "organization_tickets" do
        res = Zendesk.account(subdomain: "your_subdomain",
          email: "email@me.com", token: "jt82RfMETyIBzCBQwNuLeCh4YxdAps8rJeN99SW2")
        |> show_ticket(organization_id: "22016037")

        assert res |> hd |> Dict.get(:raw_subject) == "This is a sample ticket requested and submitted by you"
        assert length(res) == 50
      end
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
