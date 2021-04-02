defmodule ApiCommons.Parameter do

    @moduledoc """
    Handle parameters in path, body and query. Provide checks for availability, types and constraints.
    
    """

    require Logger

    alias __MODULE__
    alias ApiCommons.Request
    alias ApiCommons.Utils
    alias ApiCommons.Parameter.{Check, Resolve, Path}
    alias ApiCommons.Schema.Field
    

    @check_defaults %{position: :all, required?: true, default: nil, type: :string}
    @valid_types  [:string, :integer, :float, :time, :time_usec]

    
    defstruct [:name, :opts, :error, type: :string, value: nil, valid?: false]

    @type t(name, opts, error, type, value, valid?) :: %Parameter{name: name, opts: opts, error: error, type: type, value: value, valid?: valid?}

    @doc """
    Fetch pagination information. To limit the output.

    [Pagination options](https://www.moesif.com/blog/technical/api-design/REST-API-Design-Filtering-Sorting-and-Pagination/)

    ## Parameter
        - data (map) Received parameter to be processed.
        - defaults (Keyword) Default parameters when no pagination information was found [limit: 10, offset: 0]

    ## Pagination options
        - offset (integer) The entity where to begin
        - limit (integer) The amount of items to return

    ## Returns
        - Request struct for further processing
    """
    def pagination(params, defaults \\ [limit: 10, offset: 0])
    def pagination(params, defaults) do
       
    end

    def pagination(params = %{} , defaults) do
        temp_limit = defaults[:limit]
        limit = if (!is_nil(temp_limit) && temp_limit > 0), do: temp_limit, else: 0

        temp_offset = defaults[:offset]
        offset = if limit > 0 && !is_nil(temp_offset) && temp_offset > 0, do: temp_offset, else: 0

        params
        |> check(:limit, position: :query, type: :integer, acc: :paginate, default: limit)
        |> check(:offset, position: :query, type: :integer, acc: :paginate, defaul: offset)
    end


    @doc """
        Group parameters under filter options.
    """
    def filter(request) do

    end


    @doc """

    """
    def sort(request) do

    end


    @doc """
    Check wether or not the given parameter is provided as
    in the plug connection. 

    ## Parameter
        - conn: Plug.Conn that provides information about the connection.
        - parameter_name: Atom of the parameter name to be checked.
        - opts: Keywordlist of additional parameters provided. 


    ### Options
        - acc: Atom, accumulate data under this atom, can be later accessed by this key with Request.get(request, acc_key).
        - required? (boolean) Wether or not the parameter to check is required. Defaults to (:false)
        - default (any()) The default value for given parameter, will only be applied if no value is provided for an optional parameter.

        - check (function) A function that performs checks for the parameter
        - type (any()) The parameter type used to check. 
        - min (int) Applicable for integer, float and string values (value >= limit)
        - max (int) Applicable for integer, float and string values (value <= limit)
        - on_of (list) A list of values to check against

    ## Examples
        
        You can use parameters located in conn.query_params, conn.path_params and conn.body_params to check
        parameters at differnt location.

        iex> conn.body_params |> Parameter.check(:id, )

    """
    # def check(request=%Request{}, parameter, opts \\ [acc: :all])
    # def check(request=%Request{params: params}, parameter, opts \\ [])
    def check(check = %Check{data: data}, parameter, opts \\ []) do
        value = resolve_value(data, to_string(parameter))
        parsed_param = %Parameter{name: parameter, value: value, opts: opts, valid?: true}
        |> is_required?()
        |> cast()
        |> in_range()
        |> Check.update(check)
    end
    def check(check = %Plug.Conn{}, parameter, opts) do
        
    end

    def check(data, parameter, opts) do
        check_opts = Path.resolve(parameter, opts)
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
    defp resolve_value(nil, _), do: nil
    defp resolve_value(data, []), do: data
    defp resolve_value(data, [head | tail]), do: resolve_value(data[head], tail)
    defp resolve_value(data, parameter), do: data[parameter]


    @doc """
    Check whether or not the parameter is required for processing.

    ## Parameter
        - param (Parameter) Parameter struct containing all information about a single parameter check

    ## Returns
        - (Parameter) The updated parameter definition

    """
    defp is_required?(param = %Parameter{valid?: false}), do: param
    defp is_required?(param = %Parameter{name: name, value: value, valid?: true, opts: opts}) do
        required? = opts[:required?]
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
            :invalid_format -> %{param | error: :invalid_format, valid?: false}
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
    Check the received parameters against an Ecto.Schema.
    All fields of the schema by default are required, optional fields need to be marked.
        
    ## TODO 
        - Take required?/optional from the schema definition?
        - [References for development](https://github.com/elixir-ecto/ecto/blob/master/lib/ecto/schema.ex)
        - Use error information provided by changeset function?

    ## Parameters

        - received: Map containing received data at endpoint.
        - ecto_schema: Ecto.Schema to check against.
        - opts: Keywordlist of additional options.

    ## Opts

        - position: Atom ,one of [:body, :path, :query, :all], indicating where to take the parameter from
        - exclude: A list of parameter names as atoms to exclude
        - optional: A list of parameter names as atoms to mark as optional *deprecated*
        - endpoint: Set parsing of associations in preload mode. Meaning only keys are required as input by default *deprectaed*
        - depth: The maximum depth to which to resolve associations (default: 2) 

    ## Examples
    """
    def like_schema(received, ecto_schema, opts \\ %{exclude: [], optional: [], depth: 2}) do

        # Parameters after processing
        parsed_params = %Check{data: received, schema: ecto_schema, opts: opts}
        |> Resolve.fields()
        |> Resolve.assocs()
    end



    @doc """
    Transform parameter validation to a query.

    """
    def to_query(tables, parameters, map) do
        
    end




    @doc """
    Access the parameters accumulated under given key acc key
    in the request struct.

    ## Parameter
        - request (ApiCommons.Request) The request struct with data
        - acc_key (atom) The key under which parameters where accumulated

    ## Returns
        - (any) Values accumulated under given key.
    """
    def get(request, acc_key) do

    end
end