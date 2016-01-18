defmodule CommentTest do
  use ExUnit.Case
  use Zendesk
  use TestHelper
  use ExVCR.Mock


  test "it gets all the comments for a ticket" do
    use_cassette "all_comments" do
      res = Zendesk.account(subdomain: "your_subdomain", email: "test@test.com", password: "test")
      |> all_comments(ticket_id: "27")

      assert res |> length == 2
      assert res |> hd |> Map.get(:body) == "Dirty ticket"
    end
  end

  test "it gets all the comments for a request" do
    use_cassette "all_comments_for_request" do
      res = Zendesk.account(subdomain: "your_subdomain", email: "test@test.com", password: "test")
      |> all_comments(request_id: "1")

      assert res |> length == 4
      assert res |> hd |> Map.get(:body) == "This is the first comment. Feel free to delete this sample ticket."
    end
  end

  test "it gets a comment for a request" do
    use_cassette "comment_for_request" do
      res = Zendesk.account(subdomain: "your_subdomain", email: "test@test.com", password: "test")
      |> comment_for_request(request_id: "1", comment_id: "12655839076")

      assert res.id == 12655839076
      assert res.body == "Comment"
    end
  end

  test "it redacts a text in a comment" do
    use_cassette "redact_comment" do
      res = Zendesk.account(subdomain: "your_subdomain", email: "test@test.com", password: "test")
      |> redact_comment(ticket_id: "27", comment_id: "23487261437", text: "t")

      assert res |> Map.get(:body) == "▇▇▇▇▇ ▇i▇k▇▇"
    end
  end

  test "it can make a comment private" do
    use_cassette "make_comment_private" do
      res = Zendesk.account(subdomain: "your_subdomain", email: "test@test.com", password: "test")
      |> make_comment_private(ticket_id: "18", comment_id: "20931532428")

      assert res == :ok
    end
  end

end
