
defmodule Zendesk.CommonUtils do


  def __using__(_) do
    quote do

    end
  end

  @doc """
  Add an list item to a map

  `map`: the map to add items to

  `key`: they key that contains the list

  `item`: item to add
  """
  def add_list_item(map, key, item) do
    add_list_item(map: map, list: map[key], key: key, item: item)
  end

  defp add_list_item(map: map, list: nil, key: key, item: item) do
    Map.put(map, key, [item])
  end

  defp add_list_item(map: map, list: list, key: key, item: item) do
    Map.put(map, key, list ++ [item])
  end

  @doc """
  Set a value in a map from a list of values

  `map`: the map to set value` to

  `key`: they key to set

  `value`: they value to set

  `allowed_list`: list of allowed items

  `error_msg`: error message to throw if item is not allowed
  """
  def set_map_item(map: map, key: key, value: value, allowed_list: allowed_list, error_msg: error_msg) do
    set_map_item(map, key, value, value in allowed_list, error_msg)
  end

  def set_map_item(_, _, _, false, error_msg) do
    raise error_msg
  end

  def set_map_item(map, key, value, _contains, _error_msg) do
    Map.put(map, key, value)
  end

end
