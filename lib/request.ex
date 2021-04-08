defmodule ApiCommons.Request do
    
    import Plug.Conn
    alias __MODULE__
    alias ApiCommons.Parameter

    @library_data_key Mix.Project.config[:app]


    @type t :: %__MODULE__{
        errors: map(),
        valid?: boolean(),
        parsed: map(),
        __meta__: map()
    }

    defstruct [
        errors: %{},
        valid?: true,
        parsed: %{
            resource: nil,
            pagination: nil,
            filter: nil,
        },
        __meta__: %{
            schema: nil,
            data: nil,
        }
    ]
    

    @moduledoc """
        Describe REST API request information in Plug.Conn.
        Use private field "private" of Plug.Conn.

        https://hexdocs.pm/plug/Plug.Conn.html

    """


    @doc """
    
    """
    def init(opts), do: opts


    @doc """
    Put initial values into Plug.Conn for further processing.
    """
    def call(conn, opts) do
        library_data = Map.from_struct(%__MODULE__{})
        conn
        |> put_private(@library_data_key, library_data)
    end


    @doc """
    Create a new request struct from parameters
    Returns: %Request{}
    """
    def new(params) do
        struct(__MODULE__, params)
    end


    @doc """
    Add base library information Plug.Conn.

    Returns: Plug.Conn
    """
    def update(parameter = %Parameter{}, conn = %Plug.Conn{}) do

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
    def put_schema() do

    end

    @doc """
    Access parsed data stored in the request struct.
    
    ## Parameter

    """
    def get(request = %Request{parsed: parsed}, key) do
        parsed[key]
    end

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
    @type separated :: {map(), Plug.Conn.t()}
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
    def fetch_params(conn) do
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
end