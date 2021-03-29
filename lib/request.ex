defmodule ApiCommons.Request do
    
    alias ApiCommons.Parameter

    @moduledoc """
        Encapsulate information about an endpoint request.


        https://hexdocs.pm/plug/Plug.Conn.html

    """

    defstruct [
        :endpoint,
        :content_type,
        :data, 
        :parameter,
        :valid?
    ]

    def new(conn) do
        
        headers = Map.get(conn, :req_headers)
        parameter = Parameter.fetch(conn)

        %Request{
            endpoint: conn[:request_path]
            content_type: headers["content-type"],
        }
    end
end