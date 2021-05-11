defmodule ApiCommons.Parameter.Path do

    @moduledoc """
    Handles access & update of nested map structures.

    """
    

    @doc """
    Transform keys of different types to atoms.

    ## Parameter
    * `key` - The key to be transformed to an atom

    Returns: `atom()`
    """
    defp key(key) when is_bitstring(key), do: String.to_atom(key)
    defp key(key), do: key



    @doc """
    Wrapper to access flat and nested values inside a map.

    ## Parameter
    * `map` - The map from which to access the values
    * `path` - The path or parameter to get the value of

    Returns: `any() | nil`
    """
    @spec get(map(), list(String.t() | atom()) | atom() | String.t()) :: any()
    def get(nil, path), do: nil
    def get(map, [head | []]), do: Map.get(map, key(head))
    def get(map, [head | tail]), do: get(Map.get(map, key(head)), tail)
    def get(map, path), do: Map.get(map, key(path))



    @doc """
    Resolve the given path in an empty map.
    Creating non-existen keys.

    ## Parameter
    * `path` - The path under which to put the given value
    * `value` - The value to put under path

    Returns: `map()`
    """
    @spec put(atom(), any()) :: map()
    def put(path, value \\ nil), do: put(%{}, path, value)
    

    @doc """
    Resolve the path given for a parameter key into a map structure.
    Update an existing map with given value. Nested keys that do not exist 
    will get created.

    ## Parameter
    *  `map` - The map to put a new value in
    * `path` - The path/key to put value into 
    * `value` - The value to put into the map

    Returns: `map()`
    """
    @spec put(map(), list(), any()) :: map()
    def put(map, [head | []], value), do: Map.put(map, key(head), value)    
    def put(map, [head | tail], value) do
        head = key(head)
        default_map = if Map.has_key?(map, head) do
            Map.get(map, head)
        else
            %{}
        end
        Map.put(map, head, put(default_map, tail, value))
    end
    def put(map, path, value), do: Map.put(map, key(path), value)
end