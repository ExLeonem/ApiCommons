defmodule ApiCommons.Request do
    
    
    import Plug.Conn
    alias Plug.Conn.Unfetched

    alias __MODULE__
    alias ApiCommons.Parameter
    alias ApiCommons.Parameter.Path

    @library_data_key Mix.Project.config[:app]

    @type t :: %__MODULE__{
        data: map(),
        errors: map(),
        valid?: boolean(),
        parsed: map(),
    }

    defstruct [
        data: %{},
        errors: %{},
        valid?: true,
        parsed: %{
            resource: nil,
            pagination: nil,
            filter: nil,
        }
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
    def new(params) do
        struct(__MODULE__, params)
    end


    def from(conn = %Plug.Conn{}, schema \\ nil) do
        data = fetch_params(conn)
        %Request{
            data: data,
        }
    end


    @doc """
    Add base library information Plug.Conn.

    Returns: Plug.Conn
    """
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



    @doc """
    Fetch library information from Plug.Conn.

    Returns: {Map, Plug.Conn}
    """
    def fetch(conn = %Plug.Conn{private: private_data}) do
        private_data[@library_data_key]
    end


    # ----------------
    # Access functions for existing fields
    # -----------------------------------s

    def header(conn = %Plug.Conn{}, header_key) do
        get_req_header(conn, header_key)
    end

    def method(conn = %Plug.Conn{method: method}) do
        method
    end

    def endpoint(conn = %Plug.Conn{request_path: request_path}) do
        request_path
    end

    def query_params(conn = %Plug.Conn{query_params: query_params}) do
        query_params
    end

    def path_params(conn = %Plug.Conn{path_params: path_params}) do
        path_params
    end

    def body_params(conn = %Plug.Conn{body_params: body_params}) do
        body_params
    end


    # ----------
    # Access functions for newly added fields
    # -------------------------------------

    @doc """
    Access fields of added library data from Plug.Conn.
    """
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

    Returns: boolean
    """
    def valid?(conn = %Plug.Conn{}) do
        data(conn, :valid?, false)
    end


    @doc """
    A map of errors that occured during processing of received parameter.

    Returns: Map
    """
    def errors(conn = %Plug.Conn{}) do
        data(conn, :errors, %{})
    end


    @doc """
    Parsed pagination information

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
    Put schema for parameter valdation in Plug.Conn
    """   
    def put_schema(request = %Request{}, schema) do
        
    end


    @doc """
    Put a new error into the request.
    """
    @spec put_error(Request.t(), list(atom) | atom(), atom(), map()) :: Request.t()
    def put_error(request = %Request{}, field, error, ops) do
        IO.puts("----\nErrors: ")
        IO.inspect(request.errors)
        new_errors = Path.resolve(request.errors, field, error) 
        IO.inspect(request.errors)
        request
    end


    @doc """
    Put a parsed value into the request.
    """
    @spec put_parsed(Request.t(), list(atom) | atom, any()) :: Request.t()
    def put_parsed(request = %Request{}, field, value) do
        new_parsed = Path.resolve(request.parsed, field, value)
        Map.put(request, :parsed, new_parsed)
    end


    @doc """
    Access parsed data stored in the request struct.
    """
    @spec get(Request.t(), list(atom) | atom()) :: any()
    def get(request = %Request{parsed: parsed}, key) do
        parsed[key]
    end

    @spec get(Request.t(), list(atom) | atom(), any()) :: any()
    def get(conn = %Plug.Conn{}, key, default \\ nil) do
        lib_data = data(conn, :parsed, default)
        
        data_under_key = lib_data[key]
        if !is_nil(data_under_key) do
            data_under_key
        else
            default
        end
    end

    
    @doc """
    Remove library information from Plug.Conn.
    """
    @spec separate(Plug.Conn.t()) :: tuple()
    def separate(conn = %Plug.Conn{}) do

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
            query: (if empty_params?(query_params), do: nil, else: query_params)
        }
    end


    @doc """

    """
    defp empty_params?(_value = %Plug.Conn.Unfetched{}), do: true
    defp empty_params?(value = %{}) when map_size(value) == 0, do: true
    defp empty_params?(_value), do: false
end