defmodule ApiCommons.Request.Utils do

    import Plug.Conn

    @moduledoc """
    Utilities for faster access of Plug.Conn fields.
    """

    @doc """
    Access header information of a Plug.Conn.
    
    """
    def header(conn = %Plug.Conn{}, header_key) do
        get_req_header(conn, header_key)
    end


    @doc """
    Access the used method of a Plug.Conn.

    ## Parameter:
    * `conn` - The Plug.Conn from which to get the method information

    Returns: `atom()`
    """
    @spec method(Plug.Conn.t()) :: atom()
    def method(conn = %Plug.Conn{method: method}) do
        method
    end


    @doc """
    Get information of the endpoint encoded in the Plug.Conn.

    ## Parameter
    * `conn` - The Plug.Conn from which to get the information from.

    Returns: `String.t()`
    """
    @spec endpoint(Plug.Conn.t()) :: String.t()
    def endpoint(conn = %Plug.Conn{request_path: request_path}) do
        request_path
    end


    @doc """
    Get The query parameters from a Plug.Conn struct.

    ## Parameters
    * `conn`- The Plug.Conn from to get the information from

    Returns: `map()`
    """
    @spec query_params(Plug.Conn.t()) :: map()
    def query_params(conn = %Plug.Conn{query_params: query_params}) do
        query_params
    end


    @doc """
    Get path parameters from a Plug.Conn struct.

    ## Parameters
    * `conn`- The Plug.Conn from to get the information from

    Returns: `map()`
    """
    @spec path_params(Plug.Conn.t()) :: map()
    def path_params(conn = %Plug.Conn{path_params: path_params}) do
        path_params
    end


    @doc """
    Get body parameters from a Plug.Conn struct.

    ## Parameters
    * `conn`- The Plug.Conn from to get the information from

    Returns: `map()`
    """
    @spec body_params(Plug.Conn.t()) :: map()
    def body_params(conn = %Plug.Conn{body_params: body_params}) do
        body_params
    end
end