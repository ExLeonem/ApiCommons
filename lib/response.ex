defmodule ApiCommons.Response do

    @moduledoc """
    
    """

    import Plug.Conn
    alias ApiCommons.Request

    defmacro render(conn = %Plug.Conn{}) do

        # Call render from callers context depending the previously
        # performed actions
    end



    def error(params) do
        timestamp = Time.utc_now()
        %{
            timestamp: Time.to_string(timestamp),
            status: params[:status_code],
            error: params[:name],
            message: params[:message],
        }
    end

    def success(schema, params) do

        # expand template with schema fields
        
        %{
            
            hateoas: %{

            }
        }
    end
end