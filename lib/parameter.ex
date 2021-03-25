defmodule ApiCommons.Parameter do

    @moduledoc """
        Handle parameters in path & body. Provide checks for availability and values.
        Parse parameters passed to endpoint calls into a processable format.
    """

    require Logger

    alias __MODULE__
    alias ApiCommons.Utils
    alias ApiCommons.Parameter.{Check, Resolve}
    alias ApiCommons.Schema.Field

    @check_defaults %{position: :all, required?: true, default: nil, type: :string}
    @valid_types  [:string, :integer, :float, :time, :time_usec]

    @doc """
        Parse single 
    """
    defstruct [:name, :opts, :error, type: :string, value: nil, valid?: false]

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
            - on_of (list) A list of values to check against

        ## Examples
    """
    @default_check_params [
        type: :string
    ]
    def check(check = %Check{data: data}, parameter, opts \\ []) do
        value = resolve_value(data, parameter, opts)
        parsed_param = %Parameter{name: parameter, value: value, opts: opts, valid?: true}
        |> is_required?()
        |> cast()
        |> in_range()
        |> Check.update(check)
    end
    def check(data, parameter, opts) do
        check_opts = %{} |> Map.put(parameter, opts)
        check(%Check{data: data, schema: nil, opts: check_opts}, parameter, opts)
    end

    @doc """
        Resolve the value of a parameter by it's name.

        ## Parameter
            - param (Parameter) 
            - data ()
            - opts (Keyword) Keyword list of passed options
        
        ## Returns
            - The value if found in the data or nil
    """
    defp resolve_value(nil, _, _), do: nil
    defp resolve_value(data, parameter, [position: position]) do
        sub_values = data[position]
        _resolve_value(sub_values, parameter)
    end

    defp resolve_value(data, [head | tail], opts) do
        sub_values = data[head]
        |> resolve_value(tail, opts)
    end
    defp resolve_value(data, [], _), do: data
    defp resolve_value(data, parameter, _), do: data[parameter]

    defp _resolve_value(nil, _), do: nil
    defp _resolve_value(data, []), do: data
    defp _resolve_value(data, [head | tail]), do: _resolve_value(data[head], tail)
    defp _resolve_value(data, parameter), do: data[parameter]


    @doc """

    """
    # defp resolve_param_name(map, [])
    # defp resolve_param_name(map, [head | tail]) do

    # end
    
    # defp resolve_parameter_name(map, parameter) do

    # end


    @doc """
        Check whether or not the parameter is required for processing.

        ## Parameter
            - param (Parameter) Parameter struct containing all information about a single parameter check

        ## Returns
            - (Parameter) The updated parameter definition

    """
    defp is_required?(param = %Parameter{valid?: false}), do: param
    defp is_required?(param = %Parameter{name: name, value: value, valid?: true, opts: opts}) do
        required? = opts[:required]
        default_value = opts[:default]

        if (required? && (value || default_value)) || !required? do
            %{param | value: (value || default_value)}
        else
            %{param | valid?: false, error: :required_missing}
        end
    end


    @doc """
        Cast a parameter to specific type.

        ## Parameter
            - param (Parameter) 

        ## Returns
            - 
    """
    defp cast(param = %Parameter{valid?: false}), do: param
    defp cast(param = %Parameter{name: name, value: value, valid?: true, opts: opts}) do
        type = opts[:type]
        casted_value = Utils.cast(value, type)

        case casted_value do
            :cast_error -> %{param | error: :cast_error, valid?: false}
            _ -> %{param | value: casted_value}
        end
    end


    
    defp in_range(param = %Parameter{valid?: false}), do: param
    defp in_range(param = %Parameter{name: name, value: value, type: type, opts: opts}) do
        min = opts[:min]
        max = opts[:max]

        in_min_range = !min || (min && min <= _range_metric(value, type))
        in_max_range = !max || (max && max >= _range_metric(value, type))
        case in_min_range && in_max_range do
            true -> param
            false ->
                %{param | valid?: false, error: :range_error}
        end
    end


    @doc """
        Turn value into a range comparable value. 

        ## Parameter

        ## Returns
            - (int) Integer value to make range comparisons.

        ## Examples

        iex> _range_metric("hey", :string)
        iex> 3

        iex> range_metric("helloworld", :string)
        iex> 8
    """
    defp _range_metric(value, :string), do: String.length(value)
    defp _range_metric(value, type) when type in [:integer, :float], do: value
    defp _range_metric(value, _) do
        # Throw error because, can't check value of given type for range
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
    def in_path(params, field, check) do
        # in_path? = Map.get(params, path)

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