defmodule ApiCommons.Endpoint.Parameter do

    @moduledoc """
        Handle parameters in path & body. Provide checks for availability and values.
        Parse parameters passed to endpoint calls into a processable format.
    """

    require Logger

    alias ApiCommons.Endpoint.Utils
    alias ApiCommons.Endpoint.Parameter.Check
    alias ApiCommons.Schema.Field

    @check_defaults %{position: :path, required?: true, default: nil, type: nil}


    @doc """
        Merge parameters from Plug.Conn and parameters received at endpoint.
        Puts the merged parameter into a map.

        ## Parameter
            - conn (Plug.Conn) 
            - params (Map)

        ## Returns
            - Map containing all parameters %{path: [], query: [], body: []}

        ## Examples
    """
    def merge(conn, params) do
        # BODY PARAMETERS can be found in conn.body_params
        # QUERY PARAMETERS can be foun din conn.query_params

        body_params = conn.body_params
        query_params = conn.query_params
        
        %{
            body: body_params,
            query: query_params
        }
    end

    @doc """
        Check wether or not the given parameter is provided as
        in the plug connection. 

        ## Parameter
            - conn (Plug.Conn) Provides information about the connection
            - parameter_name (atom) The parameter name to be checked
            - opts (Map) Additional parameters provided to direct 


        ### Options:
            - position (atom) One value of [:path, :query, :body], indicates the position of the parameter. Defaults to (:path)
            - required? (boolean) Wether or not the parameter to check is required. Defaults to (:false)
            - default (any()) The default value for given parameter, will only be applied if no value is provided for an optional parameter.
            - type (any()) The parameter type used to check. 
            - error (fn()) A function that takes an atom of type [:type, :length]

        ## Examples
    """
    def check(conn, parameter_name, opts) do
        # BODY PARAMETERS can be found in conn.body_params
        # QUERY PARAMETERS can be foun din conn.query_params


        # Is conn a Plug.Conn or a Parameter.
    end

    def check(conn, paramter_name, type \\ :required, opts) do

    end


    @doc """
        Perform checkups of path parameters.

        ## Parameter
            - received (Map) Parameters received at endpoint
            - param_name (atom) The name of the parameter to check
            - opts (Map) Additional options

        ## Opts
            - position (atom) 
            - required? (boolean)
            - default (any)
            - type (any)
            - error (function)

        ## Examples
    """
    def path(received, param_name, opts) do

    end

    def path(received, param_name, required?, opts) do

    end


    @doc """
        Perform query parameter checkups.
    """
    def query(received, param_name, opts) do
    
    end


    @doc """
        Check the received parameters against an Ecto.Schema.
        All fields of the schema by default are required, optional fields need to be marked.
        
        TODO: 
            - Take required?/optional from the schema definition?
            - [References for development](https://github.com/elixir-ecto/ecto/blob/master/lib/ecto/schema.ex)
            - Use error information provided by changeset function?

        ## Parameter

        ## Opts
            - position (atom) One of [:body, :path, :query, :all], indicating where to take the parameter from
            - exclude (list(atom)) A list of parameter names as atoms to exclude
            - optional (list(atom)) A list of parameter names as atoms to mark as optional
            - endpoint (preload) Set parsing of associations in preload mode. Meaning only keys are required as input by default
            - depth (integer) The maximum depth to which to resolve associations (default: 2)
            - 

        ## Examples
    """
    def like_schema(received, ecto_schema, opts \\ %{exclude: [], optional: [], depth: 2, endpoint: :load}) do

        # Parameters after processing
        parsed_params = %Check{data: received, schema: ecto_schema, opts: opts}
        |> resolve_fields()
        |> resolve_assocs()
    end


    @doc """
        Resolve fields of a schema

        TODO: Use preload key to ignore all keys except id
    """
    defp resolve_fields(checks = %Check{schema: ecto_schema}) do
        # Collect parse regular fields of schema
        ecto_schema.__schema__(:fields)
        |> resolve_fields(checks)
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
    defp resolve_fields([], checks), do: checks
    defp resolve_fields(fields, checks = %Check{data: data, schema: ecto_schema, opts: opts}) when is_list(data) do
        schema_fields = ecto_schema.__schema__(:fields)

        # TODO: extract keys, not nulls
        if length(schema_fields) <= 2 do

        end

    end
    defp resolve_fields([field | next_fields], checks = %Check{data: data, schema: ecto_schema, opts: opts}) do
        to_exclude = opts[:exclude]
        is_optional = opts[:optional]
        schema_changeset = ecto_schema.__changeset__

        """
            Can't
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
        resolve_fields(next_fields, checks) 
    end



    @doc """
        Resolve an assocation to be included into a
    """
    defp resolve_assocs(checks = %Check{schema: ecto_schema}) do
        # Collect information from associated
        ecto_schema.__schema__(:associations)
        |> resolve_assocs(checks)
    end

    @doc """

    """
    defp resolve_assocs([], checks), do: checks
    defp resolve_assocs([assoc | next_assocs], checks=%Check{data: data, schema: ecto_schema, opts: opts}) do
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
                new_checks = resolve_fields(related_schema_fields, %Check{data: assoc_data, schema: related_schema, opts: opts})
                Logger.info("Assoc fields resolved")

                # Check wether schema valid
                optional? = Utils.includes?(is_optional, assoc)
                merge_assoc_checks(new_checks, checks, optional?: optional?, join: field)
        end

        resolve_assocs(next_assocs, checks)
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