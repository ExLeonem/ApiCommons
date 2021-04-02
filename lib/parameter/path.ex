defmodule ApiCommons.Parameter.Path do

    
    @doc section: :path
    @doc """
        
    """
    def get(map, path) do
        get_in(map, path)
    end


    @doc """
        
    """
    def resolve(path, value \\ nil), do: resolve(%{}, path, value)
    

    @doc """
        Resolve the path given for a parameter key into a map structure.
        Update an existing map with given value    

        ## Parameter

        ## Returns
    """
    def resolve(map, [head | []], value) do
        Map.put(map, String.to_atom(head), value)
    end
    
    def resolve(map, [head | tail], value) do

        head = String.to_atom(head)
        default_map = if Map.has_key?(map, head) do
            Map.get(map, head)
        else
            %{}
        end
        Map.put(map, head, resolve(default_map, tail, value))
    end

    def resolve(map, path, value) do
        Map.put(map, path, value)
    end
end