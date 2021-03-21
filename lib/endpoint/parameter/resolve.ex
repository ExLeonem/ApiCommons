defmodule ApiCommons.Endpoint.Parameter.Resolve do
    
    @moduledoc """
        Resolve parameters passed to the endpoint.
    """
    
    alias ApiCommons.Endpoint.Parameter.Check
    alias ApiCommons.Endpoint.Utils
    require Logger

    @doc """
        Resolve fields of a schema

        TODO: Use preload key to ignore all keys except id
    """
    def fields(checks = %Check{schema: ecto_schema}) do
        # Collect parse regular fields of schema
        ecto_schema.__schema__(:fields)
        |> fields(checks)
    end


    @doc """
        Read information about ecto schema fields.

        # TODO
            - [ ] Edge Case: list of values passed, list of maps passed
            - [ ] Use Changeset to check perform additional checks?

        ## Parameters
            - 

        ## Examples
            - 

        ## Returns
            - 
    """
    defp fields([], checks), do: checks
    defp fields(field_names, checks = %Check{data: data, schema: ecto_schema, opts: opts}) when is_list(data) do
        schema_fields = ecto_schema.__schema__(:fields)

        # TODO: extract keys, not nulls
        if length(schema_fields) <= 2 do

        end

    end
    defp fields([field | next_fields], checks = %Check{data: data, schema: ecto_schema, opts: opts}) do
        to_exclude = opts[:exclude]
        is_optional = opts[:optional]
        schema_changeset = ecto_schema.__changeset__

        """
            Use information provided in changeset
        """

        Logger.info("Resolve field (#{field})")
        checks = cond do
            is_nil(data) -> %{checks | valid?: false, errors: :empty_data}
            Utils.includes?(to_exclude, field) || !Map.has_key?(schema_changeset, field) -> 
                %{checks| valid?: false}
            true -> 
                optional? = Utils.includes?(is_optional, field)
                field_type = ecto_schema.__schema__(:type, field)

                value = data
                    |> Map.get(to_string(field)) 
                    |> Utils.cast(field_type)

                Check.update(field, value, checks, optional?: optional?)
        end

        Logger.info("Finish resolve field (#{field})")
        fields(next_fields, checks) 
    end



    @doc """
        Resolve an assocation to be included into a
    """
    def assocs(checks = %Check{schema: ecto_schema}) do
        # Collect information from associated
        ecto_schema.__schema__(:associations)
        |> assocs(checks)
    end

    @doc """

    """
    defp assocs([], checks), do: checks
    defp assocs([assoc | next_assocs], checks=%Check{data: data, schema: ecto_schema, opts: opts}) do
        to_exclude = opts[:exclude]
        is_optional = opts[:optional]

        checks = cond do
            Utils.includes?(to_exclude, assoc) -> nil
            true ->
                assoc_reflection = ecto_schema.__schema__(:association, assoc)
                related_schema = Map.get(assoc_reflection, :related) # May crash, use Map.fetch/2 instead?

                # Check params against association schema
                field = Map.get(assoc_reflection, :field)
                assoc_data = Map.get(data, to_string(field))
                related_schema_fields = related_schema.__schema__(:fields)

                Logger.info("Resolve assoc (#{field})")
                new_checks = fields(related_schema_fields, %Check{data: assoc_data, schema: related_schema, opts: opts})
                Logger.info("Assoc fields resolved")

                # Check wether schema valid
                optional? = Utils.includes?(is_optional, assoc)
                merge_assoc_checks(new_checks, checks, optional?: optional?, join: field)
        end

        assocs(next_assocs, checks)
    end


    @doc """
        
        ## Parameter
            - from_check (Check) Struct to be merged in the other struct
            - to_check (Check) The struct to be merged into
            - opts (Map) Additional options passed

        ## Options
            - join (atom) The field used to join the two check structs
    """
    defp merge_assoc_checks(from_check, to_check, opts \\ %{}) do
        
        # IO.inspect(from_check)
        # IO.inspect(to_check)
        from_parsed = Map.get(from_check, :parsed)
        cond do
            from_check.valid? -> 
                new_parsed = Map.put(to_check.parsed, opts[:join], from_parsed)
                %{to_check | parsed: new_parsed}
            true ->
                # First assoc check failed, save errors under join key
                from_errors = Map.get(from_check, :errors)
                new_errors = Map.put(to_check.errors, opts[:join], from_errors)
                %{to_check | valid?: false, errors: new_errors}
        end
    end
    
end