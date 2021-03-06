defmodule ApiCommons.Schema.Field do

    @moduledoc """
        Helper functions for transformation of field values or checkups.

        Functions to transform specific struct of Ecto.Schema into a regular map format.
    """

    @doc """
        Rename a field name.

        ## Parameters
            - field_name (atom) The atom which to transform
            - rename_map (Map|atom) A map of renames %{from_field_name: :to_field_name} or a direct value as an atom

        Returns: On successful mapping a new field name else the old one.


        ## Examples

        iex> ApiCommons.Schema.Field.rename(:old_field_name, %{old_field_name: :new_field_name})
        :new_field_name

        iex> ApiCommons.Schema.Field.rename(:old_field_name, :new_field_name)
        :new_field_name

        iex> ApiCommons.Schema.Field.rename(:old_field_name, nil)
        :old_field_name
    """
    def rename(field_name, rename_map)
    def rename(field_name, nil), do: field_name
    def rename(_field_name, rename_value) when is_atom(rename_value), do: rename_value
    def rename(field_name, rename_map) when is_map(rename_map) and is_atom(field_name), do: rename(field_name, rename_map[field_name])
    def rename(_field_invalid_type, _invalid_type) do
        # Error: Rename_map is neither a Map nor atom. 
        
    end

    

    @doc """
        Should the given field be skipped? 

        ## Parameter
            - field_name (atom) The name of the field to be checked
            - skip_field_names (MapSet|nil) The field names as atoms to be skipped

        Returns: true | false indicating wether the current field should be skipped

        ## Examples

        iex> ApiCommons.Field.exclude?(:article_id, [:article_id, :comment_id])
        true

        iex> ApiCommons.Field.exclude?(:article_id, [:user_id, :comment_id])
        false

        iex> ApiCommons.Field.exclude?(:article_id, "invalid_value")
        FieldError
    """
    def exclude?(field_name, skip_field_names)
    def exclude?(_field_name, nil), do: false
    def exclude?(field_name, skip_field_names) when is_list(skip_field_names), do: exclude?(field_name, MapSet.new(skip_field_names))
    def exclude?(field_name, skip_field_names) when is_map(skip_field_names) do
        IO.puts("Check values")
        MapSet.member?(skip_field_names, field_name)
    end
    def exclude?(_field_name, _skip_field_names), do: false
end