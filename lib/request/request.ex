defmodule ApiCommons.Request do

    import Plug.Conn
    alias Plug.Conn.Unfetched

    alias __MODULE__
    alias ApiCommons.Schema
    alias ApiCommons.Parameter
    alias ApiCommons.Parameter.Path

    @library_data_key Mix.Project.config[:app]

    @type t :: %__MODULE__{
        data: map(),
        errors: map(),
        valid?: boolean(),
        parsed: map(),
        tmp: map()
    }

    defstruct [
        conn: nil,
        data: %{},
        errors: %{},
        valid?: true,
        parsed: %{},
        tmp: %{}
    ]


    @moduledoc """
        Describe REST API request information in Plug.Conn.
        Use private field "private" of Plug.Conn.

        REST API relevant request headers:
        * Authorization - Carries credentials containing authentication information
        * WWW-Authenticate - Sent by server if it needs form of authentication
        * Accept-Charset - Which character sets are acceptable by the client
        * Content-Type - Indicates media type (text/html, text/JSON, ...)
        * Cache-Control - Cache policy defined by the server for this response

        https://hexdocs.pm/plug/Plug.Conn.html

    """


    @doc """
    Create a new request struct from parameters
    Returns: %Request{}
    """
    @spec new(keyword()) :: Request.t()
    def new(params) do
        struct(__MODULE__, params)
    end


    @doc """
    Create a new request object from Plug.Conn.

    ## Parameter
    * `conn` - A Plug.Conn from which to generate the request
    * `schema` - A schema representing the rest resource

    Returns: `Request.t()`
    """
    # @spec from(Plug.Conn.t(),)
    def from(conn = %Plug.Conn{}, schema \\ nil) do
        data = fetch_params(conn)
        %Request{
            conn: conn,
            data: data,
        }
    end


    @doc """
    Update the request struct to put parsed data in or an error code.

    ## Parameter
    * `value` - A parsed parameter to get inserted into the request struct
    * `request` - The request to update

    Returns: `Request.t()`
    """
    @spec update({:ok, atom(), any()} | {:error, atom(), any(), atom()}, Request.t()) :: Request.t()
    def update({:ok, name, value}, request = %Request{}) do
        request
        |> put_parsed(name, value)

    end


    def update({:error, name, value, code}, request = %Request{}) do
        opts = %{}
        opts_merged = Map.merge(%{value: value}, opts)

        request
        |> put_error(name, code, opts)
    end


    def update(%Schema{base: base, data: data, valid?: true} = param, %Request{parsed: req_data} = request) do
        %{request | parsed: Map.merge(req_data, Map.new(data))}
    end


    def update(%Schema{base: base, errors: errors, valid?: false} = param, %Request{errors: req_errors} = request) do
        %{request | valid?: false, errors: Map.merge(req_errors, Map.new(errors))}
    end


    def update(%Parameter{name: name, value: value, valid?: true}=param, request) do
        request
        |> put_parsed(name, value)
    end


    def update(%Parameter{name: name, error: code, opts: opts, valid?: false}, request) do
        request
        |> put_error(name, code, opts)
    end




    @doc """
    Fetch library information from Plug.Conn.

    Returns: {Map, Plug.Conn}
    """
    def fetch(conn = %Plug.Conn{private: private_data}) do
        private_data[@library_data_key]
    end



    # ----------
    # Access functions for newly added fields
    # -------------------------------------

    @doc """
    Access fields of added library data from Plug.Conn.
    """
    @spec data(Plug.Conn.t(), atom(), any()) :: any()
    defp data(conn = %Plug.Conn{private: private}, key, default \\ nil) do
        private_data = private[@library_data_key]

        if !is_nil(private_data) do
            private_data[key]
        else
            default
        end
    end


    @doc """
    Is the current request still valid?

    Returns: `boolean`
    """
    @spec valid?(Request.t()) :: boolean()
    def valid?(conn = %Request{valid?: is_valid?}) do
        is_valid?
    end


    @doc """
    A map of errors that occured during processing of received parameter.

    Returns: `map`
    """
    def errors(conn = %Request{errors: errors}) do
        errors
    end


    @doc """


    Returns: Map
    """
    def pagination(conn = %Plug.Conn{}) do
        data(conn, :pagination, %{})
    end

    @doc """
    Fetch filter information available.

    Returns: Map
    """
    def filter(conn = %Plug.Conn{}) do
        data(conn, :filter, %{})
    end


    @doc """
    Get information of parameters received with the endpoint request.

    ## Parameter
    - `request` - The request struct holding infomration about the current endpoint request.
    - `key` - The position of parameters, on of [:all, :path, :body, :query]

    Returns: `map()`
    """
    @spec params(Request.t()) :: map()
    def params(request, position \\ :all)
    def params(request = %Request{data: data}, :all), do: data
    def params(request = %Request{data: data}, position) when position in [:path, :body, :query], do: Map.get(data, position)


    @doc """
    Put schema for parameter valdation in Plug.Conn
    """
    def put_schema(request = %Request{}, schema) do

    end


    @doc """
    Put a new error into the request.

    ## Parameter
    * `request` - The request in which to put an error
    * `field` - The field key or path under which the error is put
    * `error` - The error code which is put into the map of error codes
    * `opts` - Additional options that can be passed

    Returns: `Request.t()`
    """
    @spec put_error(Request.t(), list(atom) | atom(), atom(), map()) :: Request.t()
    def put_error(request = %Request{}, field, error, opts) do
        new_errors = Path.put(request.errors, field, error)
        %{request | errors: new_errors, valid?: false}
    end


    @doc """
    Put a parsed value into the request.

    ## Parameter
    * `request` - The request in which to put parsed data
    * `field` - The field key or path for which to put data into the struct
    * `value` - The value to put into the struct of parsed data

    Returns: `Request.t()`
    """
    @spec put_parsed(Request.t(), list(atom) | atom, any()) :: Request.t()
    def put_parsed(request = %Request{}, field, value) do
        new_parsed = Path.put(request.parsed, field, value)
        output = Map.put(request, :parsed, new_parsed)
        # IO.inspect(output)
        # %{request | parsed: new_parsed}
        output
    end


    @doc """
    Access parsed data stored in the request struct.

    ## Parameter
    * `request` - The request struct which holds the parsed values
    * `key` - The path or key used to access the data

    Returns: `any() | nil`
    """
    @spec get(Request.t(), list(atom) | atom()) :: any()
    def get(request = %Request{parsed: parsed}, key) do
        Path.get(parsed, key)
    end


    @doc """
    Access parsed data stored in the request struct.

    ## Parameter
    * `request` - The request struct which holds parsed values
    * `key` - The path or key used to access the data
    * `default` - Default value to return if nothing was found under given key

    Returns: `any() | nil`
    """
    @spec get(Request.t(), list(atom) | atom(), any()) :: any()
    def get(request = %Request{parsed: parsed}, key, default \\ nil) do
        data_under_key = Path.et(parsed, key)
        if !is_nil(data_under_key) do
            data_under_key
        else
            default
        end
    end


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
    @spec fetch_params(Plug.Conn.t()) :: map()
    defp fetch_params(conn) do
        # BODY PARAMETERS can be found in conn.body_params
        # QUERY PARAMETERS can be foun din conn.query_params

        body_params = conn.body_params
        query_params = conn.query_params
        path_params = conn.path_params
        %{
            path: (if empty_params?(path_params), do: nil, else: path_params),
            body: (if empty_params?(body_params), do: nil, else: body_params),
            query: (if empty_params?(query_params), do: nil, else: query_params),
            header: Map.new(conn.req_headers)
        }
    end


    @doc """
    Are the parameter fields empty in Plug.Conn?

    Returns: `boolean()`
    """
    @spec empty_params?(map()) :: boolean()
    defp empty_params?(_value = %Plug.Conn.Unfetched{}), do: true
    defp empty_params?(value = %{}) when map_size(value) == 0, do: true
    defp empty_params?(_value), do: false
end
