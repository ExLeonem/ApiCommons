defmodule ApiCommons.Request do
    
    import Plug.Conn
    alias ApiCommons.Parameter
    alias __MODULE__
    
    @library_data_key :api_commons
    @default_data %{
        errors: %{},
        valid?: true,
        pagination: %{},
        resource: %{},
        filter: %{}
    }

    @moduledoc """
        Encapsulate information about an endpoint in Plug.Conn.
        Use private field "private" of Plug.Conn.

        https://hexdocs.pm/plug/Plug.Conn.html

    """

    def init(opts), do: opts

    def call(conn, opts) do
        put_private(conn, @library_data_key, @default_data)
    end


    def headers(conn = %Plug.Conn{req_headers: req_headers}) do
        req_headers
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

    def data(conn = %Plug.Conn{private: private}) do
        private[@library_data_key]
    end


    @doc """
    Put schema for parameter valdation in Plug.Conn
    """
    def put_schema() do

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