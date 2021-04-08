defmodule ApiCommons.Helpers.ConnUtils do

    use Plug.Test

    @doc """
    Creates a Plug.Conn struct for testing purposes.
    To add additional information to the Plug.Conn struct.
    Use below "put" functions.

    ## Parameter:
        - method: Atom indicating the method of request.
        - path: String representing the request path

    Returns: Plug.Conn
    """

    def create_conn(method, path), do: conn(method, path)

    @doc """
    Put arbitary data in Plug.Conn struct under given key.

    ## Parmeter:
        - conn: Plug.Conn struct
        - key: Atom indicating the place where to put the data in
        - value: Any value to be put in Plug.Conn

    Returns: Plug.Conn
    """
    def put_in_conn(conn = %Plug.Conn{}, key, value), do: Map.put(conn, key, value)

    @doc """
    Put body parameter into a Plug.Conn. **Only for testing purposes**
    """
    def put_body_params(conn = %Plug.Conn{}, value), do: put_in_conn(conn, :body_params, value)       

    @doc """
    Put query params into Plug.Conn. **Only for testing purposes**
    """
    def put_query_params(conn = %Plug.Conn{}, value), do: put_in_conn(conn, :query_params, value)

    @doc """

    """
    def put_path_params(conn = %Plug.Conn{}, value), do: put_in_conn(conn, :path_params, value)

    def put_lib_data(conn = %Plug.Conn{private: private}, value) do
        {:ok, app_name} = :application.get_application(__MODULE__)
        new_private = Map.put(private, Mix.Project.config[:app], value)
        Map.put(conn, :private, new_private)
    end

end