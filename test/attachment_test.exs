defmodule AttachmentTest do
  use ExUnit.Case, async: false
  use Zendesk
  use TestHelper
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney


  test "it uploads a file" do
    use_cassette "upload_file" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> upload_file(file_name: "a.png", file_path: "fixture/vcr_cassettes/a.png")

      assert length(res.attachments) == 1
      assert res.attachment.file_name == "a.png"
    end
  end

  test "it shows an attachment" do
    use_cassette "show_attachment" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> show_attachment(attachment_id: "2260784638")

      assert res.file_name == "a.png"
    end
  end

  test "it deletes an attachment" do
    use_cassette "delete_attachment" do
      res = Zendesk.account(subdomain: "your_subdomain",
      email: "test@zendesk.com", password: "test")
      |> delete_attachment(attachment_id: "2245806717")

      assert res == :ok
    end
  end

end
