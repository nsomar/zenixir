defmodule Zendesk.TicketField do
  @moduledoc """
  Zendesk Ticket Fields
  """

  @doc """
  Create a new Ticket Field with a type and title

  `comment`: the ticket comment
  """
  def new(type: type, title: title) do
    %{} |> set_type(type)
    |> Map.put(:title, title)
  end

  @doc """
  Set the ticket field type

  `type`: the ticket field type. can be from ["text", "textarea", "checkbox", "date", "integer", "decimal", "regexp", "tagger"]
  """
  @types ["text", "textarea", "checkbox", "date", "integer", "decimal", "regexp", "tagger"]
  def set_type(ticket_field, type)
  when type in @types do
    Map.put(ticket_field, :type, type)
  end

  def set_type(_, _) do
    raise "Wrong type passed"
  end

  @doc """
  Add a custom field option

  `name`: the custom field option name

  `value`: the custom field option value
  """
  def add_custom_field_option(field, name: name, value: value) do
    add_custom_field_option(field, field[:custom_field_options], name: name, value: value)
  end

  defp add_custom_field_option(field, nil, name: name, value: value) do
    Map.put(field, :custom_field_options, [%{name: name, value: value}])
  end

  defp add_custom_field_option(field, options, name: name, value: value) do
    Map.put(field, :custom_field_options, options ++ [%{name: name, value: value}] )
  end

  # Private

  def to_json(ticket_field) do
    Poison.encode!(ticket_field)
  end

  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:ticket_field)
  end

  def from_json_array(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:ticket_fields)
  end

end
