defmodule Zendesk.View do
  @moduledoc """
  Zendesk View
  """

  import Zendesk.CommonUtils

  @doc """
  Create a view title

  `title`: the view title
  """
  def new(title: title) do
    %{title: title}
  end

  @doc """
  Set the view output columns

  `columns`: the view output column
  """
  def set_columns(view, columns) do
    Map.put(view, :output, %{columns: columns})
  end


  @doc """
  Add a condition to the view

  `type`: the view condition type. Cana be from ["all", "any"]

  `field`: the field to use to match the tickets

  `operator`: the view condition type. Can be from ["all", "any"]

  `value`: the view condition type. Can be from ["all", "any"]
  """
  @condition_types [:all, :any]
  def add_condition(view, type: type, field: title, operator: operator, value: value)
  when type in @condition_types do
    add_list_item(view, type, %{field: title, operator: operator, value: value})
  end

  def add_condition(_view, map), do: raise "Wrong condition type passed \"#{to_char_list(map[:type])}\""

  # @condition_types [:all, :any]
  # def add_condition(view, type: type, field: title, operator: operator, value: value) do
  #   item = %{field: title, operator: operator, value: value}
  #
  #   add_condition(view,
  #   type in @condition_types,
  #   type: type,
  #   item: item,
  #   error_msg: "Condition type not allowed")
  # end
  #
  # defp add_condition(_, false, type: _, item: _, error_msg: error_msg) do
  #   raise error_msg
  # end
  #
  # defp add_condition(view, _, type: type, item: item, error_msg: _) do
  #
  #   type_map = add_condition(Map.get(view, :conditions), key: type, item: item)
  #   Map.put(view, :conditions, type_map)
  # end
  #
  # def add_condition(nil, key: key, item: item) do
  #   add_list_item(%{}, key, item)
  # end
  #
  # def add_condition(conditions, key: key, item: item) do
  #   add_list_item(conditions, key, item)
  # end

  # defp add_condition(view, _, type: type, item: item, allowed: _, error_msg: _) do
  #   add_list_item(view, :conditions, item)
  # end

  @doc """
  Decode a JSON to a Map

  `json`: the json to parse
  """
  def to_json(view) do
    Poison.encode!(%{view: view})
  end

  def from_json(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:view)
  end

  def from_json_array(json) do
    Poison.Parser.parse(json, keys: :atoms) |> elem(1) |> Dict.get(:views)
  end

end
