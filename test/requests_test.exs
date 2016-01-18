defmodule RequestTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it gets all the requests" do
    use_cassette "all_requests" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "someuser@me.com", password: "123123")
      |> all_requests

      assert length(res) == 56
      assert res |> hd |> Dict.get(:subject) == "This is a sample ticket requested and submitted by you"
    end
  end

  test "it gets requests with statuses" do
    use_cassette "request_with_statuses" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.com", password: "test")
      |> request_with_statuses(statuses: ["open", "closed"])

      assert length(res) == 56
      assert res |> hd |> Dict.get(:subject) == "This is a sample ticket requested and submitted by you"
    end
  end

  test "it gets requests for a user" do
    use_cassette "requests_for_user" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.com", password: "test")
      |> requests_for_user(user_id: "4096938127")

      assert length(res) == 56
      assert res |> hd |> Dict.get(:subject) == "This is a sample ticket requested and submitted by you"
    end
  end

  test "it gets requests for an organization" do
    use_cassette "request_for_organization" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.com", password: "test")
      |> requests_for_organization(organization_id: "22016037")

      assert length(res) == 56
      assert res |> hd |> Dict.get(:subject) == "This is a sample ticket requested and submitted by you"
    end
  end

  test "it searches for a request" do
    use_cassette "search_requests", match_requests_on: [:query] do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.com", password: "test")
      |> search_requests(query: "sample ticket")

      assert length(res) == 56
      assert res |> hd |> Dict.get(:subject) == "This is a sample ticket requested and submitted by you"
    end
  end

  test "it gets one request" do
    use_cassette "request_with_id" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.com", password: "test")
      |> request_with_id(id: "1")

      assert res.id == 1
    end
  end

  test "it can create a request model" do
    request = Request.new(subject: "Hello", comment: "The description")
    |> Request.set_status("hold")
    |> Request.set_priority("high")
    |> Request.set_type("incident")
    |> Request.set_requester_id("222")
    |> Request.set_assignee_email("email@me.com")
    |> Request.set_group_id("333")
    |> Request.set_assignee_id("444")
    |> Request.set_due_at("at")
    |> Request.set_can_be_solved_by_me(true)
    |> Request.set_is_solved(true)

    assert request.subject == "Hello"
    assert request.comment.body == "The description"
    assert request.status == "hold"
    assert request.priority == "high"
    assert request.type == "incident"
    assert request.requester_id == "222"
    assert request.assignee_email == "email@me.com"
    assert request.group_id == "333"
    assert request.assignee_id == "444"
    assert request.due_at == "at"
    assert request.can_be_solved_by_me == true
    assert request.solved == true
  end

  test "it can add the collaborator ids" do
    request = Request.new(subject: "Hello", comment: "The description")
    |> Request.set_collaborator_ids(["1", "2", "3"])

    assert request.collaborator_ids |> length == 3
    assert request.collaborator_ids == ["1", "2", "3"]
  end

  test "it can add custom fields" do
    request = Request.new(subject: "Hello", comment: "The description")
    |> Request.add_custom_fields("123", "value 1")
    |> Request.add_custom_fields("222", "value 2")

    assert request.custom_fields |> length == 2
    assert request.custom_fields |> Enum.at(0) |> Map.get(:id) == "123"
    assert request.custom_fields |> Enum.at(0) |> Map.get(:value) == "value 1"
  end

  test "it catches wrong status, type and priority" do
    request = Request.new(subject: "Hello", comment: "The description")

    assert_raise RuntimeError, "Wrong status passed", fn ->
      request |> Request.set_status("not a status")
    end

    assert_raise RuntimeError, "Wrong priority passed", fn ->
      request |> Request.set_priority("not a priority")
    end

    assert_raise RuntimeError, "Wrong type passed", fn ->
      request |> Request.set_type("not a type")
    end
  end

  test "it can create a request" do
    use_cassette "create_request" do
      request = Request.new(subject: "Hello", comment: "The description")
      |> Request.set_status("hold")
      |> Request.set_priority("high")
      |> Request.set_type("incident")
      |> Request.set_is_solved(true)

      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.com", password: "test")
      |> create_request(request: request)

      assert res.subject == "Hello"
      assert res.description == "The description"
      assert res.status == "hold"
      assert res.priority == "high"
      assert res.type == "incident"
      assert res.solved == true
    end
  end

  test "it updates a request" do
    use_cassette "update_a_request" do
      request = Request.new(subject: "Another", comment: "The description")

      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@test.com", password: "test")
      |> update_request(id: "613", request: request)

      assert res.subject == "Another"
    end
  end

end
