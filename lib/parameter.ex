defmodule ApiCommons.Parameter do

    @moduledoc """
    Parse and check path, query and body parameters received at endpoint.


    ## Examples
    To parse single parameters without defining ecto.schemas either `single/3` or `check/3`.

    ```
    alias ApiCommons.Parameter

    def index(conn, params) do
        param_check = conn
        |> Parameter.check(:name, required?: true) 

        if param_check.valid? do

        else

        end
    end

    ```

    To check parameter against existing ecto schemes you can use `check/3` or `like_schema/3`.

    ```
    alias ApiCommons.Parameter
    alias Repo.Comment, as: CommentSchema

    def create(conn, params) do
        comment = conn
        |> Parameter.like_schema(CommentSchema)

        if comment.valid? do

        else
            
        end
    end
    ```

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
    
    @type opts :: [
        # Parse configuration
        position: atom(),
        default: any(),
        
        # Constraints
        required?: boolean(),
        type: atom(),
        min: integer(),
        max: integer(),
        is: integer(),
        less_than: integer(),
        less_or_equal_than: integer(),
        greater_than: integer(),
        grater_or_equal_than: integer(),
        equal_to: integer()
    ]

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
    @spec check(Plug.Conn.t() | Request.t(), atom() | map() | Schema.schema(), keyword()) :: Plug.Conn.t()
    
    def check(conn = %Plug.Conn{}, parameter, opts) when is_map(parameter) do
        Request.from(conn, parameter) |> Parameter.check(parameter, opts)
    end
    def check(conn = %Plug.Conn{}, parameter, opts) do
        Request.from(conn)
        |> Parameter.check(parameter, opts)
    end

    def check(conn = %Request{}, parameter, opts) when is_map(parameter), do: like_map(conn, parameter, opts)
    def check(conn = %Request{}, parameter, opts) when is_atom(parameter) do
        if Code.ensure_loaded?(parameter) do
            like_schema(conn, parameter, opts)
        else
            single(conn, parameter, opts)
        end
    end

    def check(conn, parameter, opts) when not is_map(parameter) and not is_atom(parameter), 
        do: raise ArgumentError, message: "No functions head matching for &check/3. Expected Atom | Module | Ecto.Schema for 'parameter'."

    def check(conn, parameter, opts), 
        do: raise ArgumentError, message: "No functions head matching for &check/3. Expected Plug.Conn as first parameter."


    @doc """
    Parse a single parameter from received values at endpoint.

    ## Parameter
    - request: A request struct.
    - parameter: Name of the parameter given as atom.
    - opts: Keywordlist of additional options.

    ## Options
    * `:position` - The position of the parameters, one of [:path, :query, :body, :all].
    * `:acc` - Atom, accumulate data under this atom, can be later accessed by this key with Request.get(request, acc_key).
    * `:default` - Any value that should be used as the default value
    * `:check` - Function that performs additional checks for the parameter

    ### Constraints
    * `:required?` - boolean Wether or not the parameter to check is required. Defaults to (:false)
    * `:type` - Atom representing the expected type of the parameter

    #### String 
    * `:min` - Check whether String has minimal length (exclusive). For numeric values use `:less_than` or `:less_or_equal_to`.
    * `:max` - Check whether String has maximal length (exclusive). For numeric values use `:greater_than` or `:greater_or_equal_to`.
    * `:is` - Check whether string is of given length. For numeric comparisons use `:equal_to`.
    * `:counter` - Which value to use to count string length? Allowed values `:grapheme`, `:codepoints` or `:bytes`

    #### Numeric values
    * `:less_than` - Integer to check against actual parameter value. Is parameter value smaller than :less_than? (exclusive)
    * `:less_or_equal_to` - Integer to check against actual paramter value. Is parameter value smaller or equal to :less_or_equal_than? (inclusive)
    * `:greater_than` - Integer to check against actual paramter value. Is parameter value bigger than :greater_than?. (exclusive)
    * `:greater_or_equal_to` - Integer to check against actual paramter value. Is parameter value greater or equal to :greater_or_equal_than? (inclusive)
    * `:equal_to` - Is paramter value eqault to integer of :equal_to?


    ## Examples
        You can use parameters located in conn.query_params, conn.path_params and conn.body_params to check
        parameters at differnt location.

        iex> conn.body_params |> Parameter.check(:id, )

    """
    @spec single(Request.t(), atom(), keyword()) :: Request.t()
    def single(request = %Request{data: data}, parameter, opts \\ []) when is_atom(parameter) do
        value = resolve_value(data, to_string(parameter))
        {type, _} = Keyword.pop(opts, :type) 
        opts = if is_map(opts), do: opts, else: Map.new(opts)
        
        %Parameter{name: :parameter, value: value, type: type || :string, opts: opts}
        |> cast()
        |> validate()
        |> Request.update(request) 

        # %Parameter{name: parameter, }
        # [:name, :opts, :error, type: :string, value: nil, valid?: true]
    end
    def single(request, parameter, opts), do: raise ArgumentError, message: "Error casting single parameter."


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
    Cast a parameter value to specific type.

    ## Examples

        iex> param = %Parameter{name: :test, value: "12", type: :integer}
        iex> cast(param)
        %Parameter{
            name: :test,
            value: 12,
            valid?: true,
            opts: %{}}

        iex> param = %Parameter{name: :test, value: "1k", type: :integer}
        iex> cast(param)
        %Parameter{
            name: :test,
            valuer: 12,
            valid?: false,
            errors: [:cast]}

    """
    @spec cast(Parameter.t()) :: Parameter.t()
    defp cast(param = %Parameter{valid?: false}), do: param
    defp cast(param = %Parameter{name: name, value: value, type: type, valid?: true, opts: opts}) do

        casted_value = Utils.cast(value, type)
        case casted_value do
            :cast_error -> %{param | error: :cast_error, valid?: false}
            :invalid_format -> %{param | error: :invalid_format, valid?: false}
            _ -> %{param | value: casted_value}
        end
    end


    @doc """
    Validate constraints given for parameter definition
    """
    @spec validate(Parameter.t()) :: Parameter.t()
    defp validate(param = %Parameter{valid?: false}), do: param
    defp validate(param = %Parameter{name: name, value: value, type: type, opts: opts}), do: Constraint.validate(name, value, type, opts)
end