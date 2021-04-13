defmodule ApiCommons.Utils do
      @moduledoc """
            Utils useable for parameter checks.
        """

        require Logger

        @ecto_types [:id, :binary_id, :integer, :float, :boolean, :string, :binary, :map, :decimal]
        @error_codes [:cast_error, :wrong_type]

        @doc """
            Check if the passed value is of given type.
    
            ## Parameter
                - field_value: any() value to check against
                - type: Ecto.Type field primitives to check for, one of [:integer, :float, :string, ....]
        """
        def is_type(field_value, type) do
            case cast(field_value, type) do
                :cast_error -> false
                _ -> true
            end
        end

        @doc """
            Cast value of a paramter to a specific type. 
            If value already of specified type, just return the value

            ## Parameter
                - value (any) The value to parse
                - type (atom) One of following values [:id, :integer, :float, ...]. Representing the type to parse to

            ## Returns
                - The casted value or an error code {error_type, code}

            ## Examples

        """ 
        @spec cast(any(), atom()) :: any()        
        def cast(value, _) when value in [[], {}, %{}, nil] do
            # Empty value
            nil
        end

        def cast(value, type) when type in [:id, :integer] and is_integer(value), do: value
        def cast(value, type) when type in [:id, :integer] do
            try do
                String.to_integer(value)
            rescue 
                _ -> :cast_error
            end
        end

        def cast(value, :float) when is_float(value), do: value
        def cast(value, :float) do

            try do
                String.to_float(value)
            rescue
               _ -> :cast_eror
            end
        end

        def cast(value, :boolean) when is_boolean(value), do: value
        def cast(value, :boolean) do
            truthy_atom = String.to_atom(value)
            case truthy_atom do
                :true -> true
                :false -> false
                _ -> :cast_error
            end
        end

        def cast(value, :binary) when is_binary(value), do: value
        def cast(value, :binary) do
            Logger.warn("Failed casting binary")
            :cast_error
        end

        def cast(value, {:array, inner_type}) when is_list(value) do
            Enum.map(value, fn x -> cast(x, inner_type) end)
        end
        def cast(_value, {:array, _inner_type}), do: :cast_error

        def cast(value, :map) when is_map(value), do: value
        def cast(value, :map) do
            
        end

        def cast(value, {:map, mappings}) do
            # Cast map of values to a specific type
        end

        def cast(value, {:list, type}) do
            # Cast list of values to a specific type
        end

        def cast(value, :string) do
            # Values received are usually are strings
            value
        end

        def cast(value = %Time{}, type) when type in [:time, :time_usec] , do: value
        def cast(value, type) when is_bitstring(value) and type in [:time, :time_usec]  do
            case Time.from_iso8601(value) do
                {:ok, time} -> time
                {:error, error_code} -> error_code
            end
        end
        def cast(value, type) when type in [:time, :time_usec], do: :wrong_type
        
        def cast(value, type) do
            # No value matched, throw an error
            value
        end


        @doc """
            Check wether field should be excluded for further processing.

            ## Parameter
                - field_name (atom) The field name to check against
                - atom_list (list(atom)|atom) A list of fields or a single value to exclude.

            ## Returns


            ## Examples
    
        """
        def includes?(nil, field_name), do: false
        def includes?([], field_name), do: false
        def includes?(atom_list, field_name) when is_atom(atom_list), do: field_name == atom_list
        # def includes?(atom_list, _field_name) when not is_list(atom_list), do: false
        def includes?(atom_list, field_name) do
            Enum.any?(atom_list, fn x -> field_name == x end)
        end
end