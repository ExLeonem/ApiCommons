defmodule ApiCommons.Endpoint.Utils do
      @moduledoc """
            Utils useable for parameter checks.
        """

        @ecto_types [:id, :binary_id, :integer, :float, :boolean, :string, :binary, :map, :decimal, ]

        @doc """
            Check if the passed value is of the schema type.

            ## Parameter
                - field_value (any) Any value to check against
                - type (Ecto.Type) Field type primitives to check for
        """
        def is_type(field_value, type) when type in [:id, :integer]  do
            Integer.parse()
        end

        def is_type(field_value, :binary_id) do
            # Elixir binary
        end
        
        def is_type(field_value, :binary) do
            # Elixir 
        end

        def is_type(field_value, :integer) when is_integer(field_value) do
            
        end
        def is_type(field_value, :integer) do
            # elixir integer
        end

        def is_type(field_value, :float) do
            # Elixir float
        end

        def is_type(field_value, :boolean) do

        end

        def is_type(field_value, :string) do

        end

        # def is_type() do
            
        # end

        def is_type(field_value, :schema) do

        end

        def is_type(field_value, type) do

        end


        @doc """
            Cast value of a paramter to a specific type.

            ## Parameter
                - value (any) The value to parse
                - type (atom) One of following values [:id, :integer, :float, ...]. Representing the type to parse to

            ## Returns

            ## Examples

        """ 
        def cast(value, type) when type in [:id, :integer] do
            case Integer.parse(value) do
                {parsed_value, _} -> parsed_value
                _ -> :cast_error
            end
        end

        def cast(value, :float) do
            case Float.parse(value) do
                {parsed_value, _} -> parsed_value
                _ -> :cast_error
            end
        end

        def cast(value, :boolean) do
            truthy_atom = String.to_atom(value)
            case truthy_atom do
                :true -> true
                :false -> false
                _ -> :cast_error
            end
        end

        def cast(value, {:array, inner_type}) when is_list(value) do
            Enum.map(value, fn x -> cast(x, inner_type) end)
        end
        def cast(_value, {:array, _inner_type}), do: :cast_error

        def cast(value, :map) do
            
        end


        # Check wether field should be excluded
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