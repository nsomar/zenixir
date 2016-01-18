defmodule Zendesk.Request do

  import Zendesk.CommonUtils

  @moduledoc """
  Zendesk Request
  """

  @doc """
  Create a new Request

  `subject:`: the request subject

  `comment:`: the request comment
  """
  def new(subject: subject, comment: comment) do
    %{subject: subject, comment: %{body: comment}}
  end

  @doc """
  Set the request status

  `status`: the ticket status. can be from ["open", "pending", "hold", "solved", "closed"]
  """
  @statuses ["open", "pending", "hold", "solved", "closed"]
  def set_status(request, status) do

    set_map_item(map: request,
    key: :status,
    value: status,
    allowed_list: @statuses,
    error_msg: "Wrong status passed")
  end

  @doc """
  Set the request priority

  `priority`: the request priority. can be from ["urgent", "high", "normal", "low"]
  """
  @priorities ["urgent", "high", "normal", "low"]
  def set_priority(request, priority) do
    set_map_item(map: request,
    key: :priority,
    value: priority,
    allowed_list: @priorities,
    error_msg: "Wrong priority passed")
  end

  @doc """
  Set the request type

  `type`: the request type. can be from ["problem", "incident", "question", "task"]
  """
  @types ["problem", "incident", "question", "task"]
  def set_type(request, type) do
    set_map_item(map: request,
    key: :type,
    value: type,
    allowed_list: @types,
    error_msg: "Wrong type passed")
  end

  @doc """
  Add a custom field in the request

  `id`: the custom field id

  `value`: the custom field value
  """
  def add_custom_fields(request, id, value) do
    add_list_item(request, :custom_fields, %{id: id, value: value})
  end

  @doc """
  Set the request requester id

  `requester_id`: the requester id
  """
  def set_requester_id(request, requester_id) do
    Map.put(request, :requester_id, requester_id)
  end

  @doc """
  Set the request assignee id

  `assignee_id`: the ticket assignee id
  """
  def set_assignee_id(request, assignee_id) do
    Map.put(request, :assignee_id, assignee_id)
  end

  @doc """
  Set the assignee email

  `assignee_email`: the assignee email to add
  """
  def set_assignee_email(request, assignee_email) do
    Map.put(request, :assignee_email, assignee_email)
  end

  @doc """
  Set the group id for the request

  `group_id`: the group id to set
  """
  def set_group_id(request, group_id) do
    Map.put(request, :group_id, group_id)
  end

  @doc """
  Set the request collaborator ids

  `collaborator_ids`: the request collaborator ids
  """
  def set_collaborator_ids(request, collaborator_ids) do
    Map.put(request, :collaborator_ids, collaborator_ids)
  end

  @doc """
  Set the request can be solved by me flag

  `can_be_solved_by_me`: can the request be solved by me
  """
  def set_can_be_solved_by_me(request, can_be_solved_by_me) do
    Map.put(request, :can_be_solved_by_me, can_be_solved_by_me)
  end

  @doc """
  Is the request solved

  `is_solved`: is the ticket solved
  """
  def set_is_solved(request, is_solved) do
    Map.put(request, :solved, is_solved)
  end

  @doc """
  Set the due date for the request

  `due_at`: the ticket due at date
  """
  def set_due_at(request, due_at) do
    Map.put(request, :due_at, due_at)
  end

  # Private

  def to_json(request) do
    Poison.encode!(request)
  end

  def from_json_array(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:requests)
  end

  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:request)
  end

end
