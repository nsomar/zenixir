defmodule Zendesk.Ticket do

  import Zendesk.CommonUtils

  @moduledoc """
  Zendesk Ticket
  """

  @doc """
  Create a new Ticket map with a comment

  `comment`: the ticket comment
  """
  def new(comment) do
    %{comment: %{body: comment}}
  end

  @doc """
  Set the subject ticket

  `subject`: the ticket subject
  """
  def set_subject(ticket, subject) do
    Map.put(ticket, :subject, subject)
  end

  @doc """
  Add a requester with name and email to the ticket

  `name`: requester name

  `email`: requester email
  """
  def add_requester(ticket, name: name, email: email) do
    Map.put(ticket, :requester, %{name: name, email: email})
  end

  def add_requester(ticket, email: email) do
    Map.put(ticket, :requester, %{name: email, email: email})
  end

  @doc """
  Add a custom field in the ticket

  `id`: the custom field id

  `value`: the custom field value
  """
  def add_custom_fields(ticket, id, value) do
    add_list_item(ticket, :custom_fields, %{id: id, value: value})
  end

  @doc """
  Add a collaborator with name and email to the ticket

  `name`: collaborator name

  `email`: collaborator email
  """
  def add_collaborator(ticket, name: name, email: email) do
    add_list_item(ticket, :collaborators, %{name: name, email: email})
  end

  def add_collaborator(ticket, email: email) do
    add_list_item(ticket, :collaborators, email)
  end


  @doc """
  Add a collaborator with an id to the ticket

  `id`: the collaborator id
  """
  def add_collaborator(ticket, id: id) do
    add_list_item(ticket, :collaborators, id)
  end

  @doc """
  Set the ticket requester id

  `requester_id`: the requester id
  """
  def set_requester_id(ticket, requester_id) do
    Map.put(ticket, :requester_id, requester_id)
  end

  @doc """
  Set the assignee email

  `assignee_email`: the assignee email to add
  """
  def set_assignee_email(ticket, assignee_email) do
    Map.put(ticket, :assignee_email, assignee_email)
  end

  @doc """
  Set the group id for the ticket

  `group_id`: the group id to set
  """
  def set_group_id(ticket, group_id) do
    Map.put(ticket, :group_id, group_id)
  end

  @doc """
  Set the tags list to the ticket

  `tags`: the ticket list to set
  """
  def set_tags(ticket, tags) do
    Map.put(ticket, :tags, tags)
  end

  @doc """
  Set the ticket external id

  `external_id`: the ticket external id
  """
  def set_external_id(ticket, external_id) do
    Map.put(ticket, :external_id, external_id)
  end

  @doc """
  Set the the ticket problem id

  `problem_id`: the ticket problem id
  """
  def set_problem_id(ticket, problem_id) do
    Map.put(ticket, :problem_id, problem_id)
  end

  @doc """
  Set the ticket follow source id

  `via_followup_source_id`: the follow up source id
  """
  def set_via_followup_source_id(ticket, via_followup_source_id) do
    Map.put(ticket, :via_followup_source_id, via_followup_source_id)
  end

  @doc """
  Set the due date for the ticket

  `due_at`: the ticket due at date
  """
  def set_due_at(ticket, due_at) do
    Map.put(ticket, :due_at, due_at)
  end

  @doc """
  Set ticket updated stamp date

  `updated_stamp`: the ticket updated stamp date
  """
  def set_updated_stamp(ticket, updated_stamp) do
    Map.put(ticket, :updated_stamp, updated_stamp)
  end

  @doc """
  Set the ticket save update flag

  `safe_update`: the safe update flag
  """
  def set_safe_update(ticket, safe_update) do
    Map.put(ticket, :safe_update, safe_update)
  end

  @doc """
  Set the ticket forum topic id

  `forum_topic_id`: the ticket forum id
  """
  def set_forum_topic_id(ticket, forum_topic_id) do
    Map.put(ticket, :forum_topic_id, forum_topic_id)
  end

  @doc """
  Set the ticket collaborator ids

  `collaborator_ids`: the ticket collaborator ids
  """
  def set_collaborator_ids(ticket, collaborator_ids) do
    Map.put(ticket, :collaborator_ids, collaborator_ids)
  end

  @doc """
  Set the ticket assignee id

  `assignee_id`: the ticket assignee id
  """
  def set_assignee_id(ticket, assignee_id) do
    Map.put(ticket, :assignee_id, assignee_id)
  end

  @doc """
  Set the ticket type

  `type`: the ticket type. can be from ["problem", "incident", "question", "task"]
  """
  @types ["problem", "incident", "question", "task"]
  def set_type(ticket, type) do
    set_map_item(map: ticket,
    key: :type,
    value: type,
    allowed_list: @types,
    error_msg: "Wrong type passed")
  end

  @doc """
  Set the ticket status

  `status`: the ticket status. can be from ["open", "pending", "hold", "solved", "closed"]
  """
  @statuses ["open", "pending", "hold", "solved", "closed"]
  def set_status(ticket, status) do
    set_map_item(map: ticket,
    key: :status,
    value: status,
    allowed_list: @statuses,
    error_msg: "Wrong status passed")
  end

  @doc """
  Set the ticket priority

  `priority`: the ticket priority. can be from ["urgent", "high", "normal", "low"]
  """
  @priorities ["urgent", "high", "normal", "low"]
  def set_priority(ticket, priority) do
    set_map_item(map: ticket,
    key: :priority,
    value: priority,
    allowed_list: @priorities,
    error_msg: "Wrong priority passed")
  end

  # Private

  def to_json(ticket) do
    Poison.encode!(ticket)
  end

  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:ticket)
  end

  def from_json_array(json) do
    from_json_array(json, :tickets)
  end

  def from_json_array(json, key) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(key)
  end

end
