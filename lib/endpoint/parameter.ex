defmodule ApiCommons.Endpoint.Parameter do

    @moduledoc """
        Handle parameters in path & body. Provide checks for availability and values.
        Parse parameters passed to endpoint calls into a processable format.
    """

    require Logger

    alias ApiCommons.Endpoint.Utils
    alias ApiCommons.Endpoint.Parameter.{Check, Resolve}
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
    def fetch(conn) do
        # BODY PARAMETERS can be found in conn.body_params
        # QUERY PARAMETERS can be foun din conn.query_params

        body_params = conn.body_params
        query_params = conn.query_params
        path_params = conn.path_params
        
        %{
            path: path_params,
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
            - opts (Keyword) Additional parameters provided to direct 


        ### Options:
            - position (atom) One value of [:path, :query, :body], indicates the position of the parameter. Defaults to (:path)
            - required? (boolean) Wether or not the parameter to check is required. Defaults to (:false)
            - default (any()) The default value for given parameter, will only be applied if no value is provided for an optional parameter.

            - check (function) A function that performs checks for the parameter
            - type (any()) The parameter type used to check. 
            - min (int) Applicable for integer, float and string values (value >= min)
            - max (int) Applicable for integer, float and string values (value <= limit)
            - 

        ## Examples
    """
    def check(check = %Check{}, parameter_name, opts \\ []) do

        position = opts[:position]
        required? = opts[:required?]
        type = opts[:type]
        default = opts[:default]

        min = opts[:min]
        max = opts[:max]

        

    end
    def check(data, parameter_name, opts) do
        check(%Check{data: data, schema: nil}, parameter_name, opts)
    end


    @doc """
        Check for specific options
    """
    defp check_option(check, field, option, value)
    defp check_option(check = %Check{data: data}, field, :required?, true) do

    end


    defp check_option(check, field, _, _) do
        Check.update(check)
    end


    # def check(check, paramter_name, type \\ :required, opts) do

    # end


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
    def in_path(params, field, check) do
        in_path? = Map.get(params, path)
    end

    def in_path(params, field, check) do

    end


    @doc """
        Perform query parameter checkups.
    """
    def in_query(received, param_name, opts) do
    
    end


    @doc """
        Check the received parameters against an Ecto.Schema.
        All fields of the schema by default are required, optional fields need to be marked.
        
        TODO: 
            - Take required?/optional from the schema definition?
            - [References for development](https://github.com/elixir-ecto/ecto/blob/master/lib/ecto/schema.ex)
            - Use error information provided by changeset function?

        ## Parameter
            - received (map) The data received at given endpoint
            - 

        ## Opts
            - position (atom) One of [:body, :path, :query, :all], indicating where to take the parameter from
            - exclude (list(atom)) A list of parameter names as atoms to exclude
            - optional (list(atom)) A list of parameter names as atoms to mark as optional *deprecated*
            - endpoint (preload) Set parsing of associations in preload mode. Meaning only keys are required as input by default *deprectaed*
            - depth (integer) The maximum depth to which to resolve associations (default: 2) 

        ## Examples
    """
    def like_schema(received, ecto_schema, opts \\ %{exclude: [], optional: [], depth: 2}) do

        # Parameters after processing
        parsed_params = %Check{data: received, schema: ecto_schema, opts: opts}
        |> Resolve.fields()
        |> Resolve.assocs()
    end



    def required?(key)

    @doc """

    """
    def max(key, value, limit) when is_integer(value) and value <= limit, do: {key, value}
    def max(key, value, limit) when is_integer(value), do: {key, value, {:max_bound_err, limit}}
    def max(key, value, limit) when is_bitstring(value) do
        cond do
            String.length(value) <= limit -> {key, value}
            true -> {key, value, {:max_bound_err, limit}}
        end
    end
end