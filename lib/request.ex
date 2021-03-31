defmodule ApiCommons.Request do
    
    alias ApiCommons.Parameter
    alias __MODULE__

    @moduledoc """
        Encapsulate information about an endpoint request.


        https://hexdocs.pm/plug/Plug.Conn.html

    """

    defstruct [
        :endpoint,
        :content_type,
        :data, 
        :parameter, # %Parameter.Check{}
        :valid?, # Is valid response?
        :__meta__ # Meta information for processing {:schema, }
    ]

    def new(conn) do
        headers = Map.get(conn, :req_headers)
        parameter = fetch_params(conn)

        %Request{
            endpoint: conn[:request_path],
            content_type: headers["content-type"]
        }
    end


    # @doc """
    #     Get pagination information
    # """
    # def get_pagination(request) do

    # end




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