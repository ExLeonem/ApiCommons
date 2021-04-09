defmodule ApiCommons.Parameter do

    @moduledoc """
    Handle parameters in path, body and query. Provide checks for availability, types and constraints.
    
    """

    import Plug.Conn
    require Logger

    alias __MODULE__
    alias ApiCommons.Request
    alias ApiCommons.Utils
    alias ApiCommons.Parameter.{Check, Resolve, Path, Constraint}
    alias ApiCommons.Parser.{Schema}
    alias Ecto.Schema
    
    
    @valid_types  [:string, :integer, :float, :time, :time_usec]
    @check_defaults [position: :all, required?: true, default: nil, type: :string, acc: :filter]
    
    @type error :: [{atom(), String.t()}]
    @type t :: %__MODULE__{
        name: atom(), 
        opts: keyword(), 
        error: error, 
        type: atom(), 
        value: any(), 
        valid?: boolean(), 
    }

    defstruct [:name, :opts, :error, type: :string, value: nil, valid?: true]


    @doc """
    Validate the given parameter against received body, path or query parameters. 
    The parameter can be either `Atom | Map | Ecto.Schema`.
    This function is a generic interface and dispatches to `single/3`, `like_schema/3`, `like_map/3`.

    Optional parameters depending the type of parameter. 
    Check `single/3`, `like_schema/3`, `like_map/3` for more information.
    """
    @spec check(Plug.Conn.t(), atom() | map() | Schema.schema(), keyword()) :: Plug.Conn.t()
    def check(conn = %Plug.Conn{}, parameter, opts) when is_map(parameter), do: like_map(conn, parameter, opts)
    def check(conn = %Plug.Conn{}, parameter, opts) when is_atom(parameter) do
        if Code.ensure_loaded?(parameter) do
            like_schema(conn, parameter, opts)
        else
            single(conn, parameter, opts)
        end
    end

    def check(data, parameter, opts) when not is_map(parameter) and not is_atom(parameter), 
        do: raise ArgumentError, message: "No functions head matching for &check/3. Expected Atom | Module | Ecto.Schema for 'parameter'."

    def check(data, parameter, opts), 
        do: raise ArgumentError, message: "No functions head matching for &check/3. Expected Plug.Conn as first parameter."



    @doc """
    Resolve the value of a parameter by it's name.

    ## Parameter
    * `:param` - (Parameter) 
    * `:data` - ()
    * `:opts` - (Keyword) Keyword list of passed options
    
    Returns: `any() | nil`
    """
    defp resolve_value(nil, _), do: nil
    defp resolve_value(data, []), do: data
    defp resolve_value(data, [head | tail]), do: resolve_value(data[head], tail)
    defp resolve_value(data, parameter), do: data[parameter]



    @doc """
    Parse a single parameter from received data

    ## Opts
    * ':position` - The position of the parameters, one of [:path, :query, :body, :all].
    * `:acc` - Atom, accumulate data under this atom, can be later accessed by this key with Request.get(request, acc_key).
    * `:required?` - boolean Wether or not the parameter to check is required. Defaults to (:false)
    * `:default` - Any value that should be used as the default value
    * `:check` - Function that performs additional checks for the parameter
    * `:type` - Atom representing the expected type of the parameter

    * `:min` - Integer
    * `:max` - Integer Applicable for integer, float and string values (value <= limit)
    * `:on_of` - List A list of values to check against

    ## Examples
        You can use parameters located in conn.query_params, conn.path_params and conn.body_params to check
        parameters at differnt location.

        iex> conn.body_params |> Parameter.check(:id, )
    """
    @spec single(Plug.Conn.t(), atom(), keyword()) :: Plug.Conn.t()
    def single(conn = %Plug.Conn{}, parameter, opts \\ []) do
        data = Request.fetch_params(conn)
        value = resolve_value(data, to_string(parameter))
        opts = if is_map(opts), do: opts, else: Map.new(opts)
        
        %Parameter{name: parameter, value: value, opts: opts}
        |> Constraints.is_required?()
        |> Constraints.of_type()
        |> Constraints.in_range()
        |> Request.update(conn)

        # %Parameter{name: parameter, }
        # [:name, :opts, :error, type: :string, value: nil, valid?: true]
        # check(%Check{data: data, schema: nil, opts: check_opts}, parameter, opts)
    end


    @doc """
    Check received parameters against an Ecto.Schema.
    All fields of the schema by default are required, optional fields need to be marked.
        
    ## TODO 
    - [ ] Take required?/optional from the schema definition?
    - [ ] [References for development](https://github.com/elixir-ecto/ecto/blob/master/lib/ecto/schema.ex)
    - [ ] Use error information provided by changeset function?

    ## Opts
    * `:position` - One of [:body, :path, :query, :all], indicating where to take the parameter from
    * `:exclude` - A list of parameter names as atoms to exclude
    * `:optional` - A list of parameter names as atoms to mark as optional *deprecated*
    * `:endpoint` - Set parsing of associations in preload mode. Meaning only keys are required as input by default *deprectaed*
    * `:depth` - The maximum depth to which to resolve associations (default: 2) 
    """
    @spec like_schema(Plug.Conn.t(), module(), keyword()) :: Plug.Conn.t()
    def like_schema(conn = %Plug.Conn{}, schema, opts) do
        is_module = Code.ensure_loaded?(schema)
        is_schema = if is_module do
             schema.__info__(:functions) |> Keyword.has_key?(:__schema__)
        else
            false
        end

        cond do
            is_module && is_schema -> 
                parse_schema(schema)
            true -> raise ArgumentError, message: "Exception in &check/3. Passed module is not a schema."    
        end
    end

    defp parse_schema(schema) do
        
    end

    @doc """
    Check received parameters against multiple definitions contained in map.

    ## Opts
    * `:position` - One of [:body, :path, :query, :all], indicating where to take the parameter from
    * `:exclude` - A list of parameter names as atoms to exclude
    * `:optional` - A list of parameter names as atoms to mark as optional *deprecated*
    * `:endpoint` - Set parsing of associations in preload mode. Meaning only keys are required as input by default *deprectaed*
    * `:depth` - The maximum depth to which to resolve associations (default: 2) 
    """
    @spec like_map(Plug.Conn.t(), map(), keyword()) :: Plug.Conn.t()
    def like_map(conn = %Plug.Conn{}, map_def, opts) do
        
    end
end