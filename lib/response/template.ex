defmodule ApiCommons.Response.Template do


    @doc """

    """
    def default_json_error(status_code, name, message) do

        timestamp = Time.utc_now()
        %{
            timestamp: Time.to_string(timestamp),
            status: status_code,
            error: name,
            message: message,
        }
    end

    @doc """

    """
    def default_json_errors(error_codes) do
        
    end

end