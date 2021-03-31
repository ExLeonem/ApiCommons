defmodule ApiCommons.Schema do


    @error_schema [:timestamp, :status, :code, :message, :developer_message, :more_info]
    @success_schema []


    @doc """
        ## JSON Schema
        
        Example of possible value of valid response.

        Single resouce

        ```json
            {
                
                meta: {

                }
            }
        ```
        
        Multi resources
        ```json
            {
                "status": 200,
                "data": [
                    {
                        "name": "John Doe",
                        "age": 22,

                    },
                    {
                        "name": "Jane Doe",
                        "age": 23,
                    }
                    ...
                ],
                meta: {
                    "offset": 0,
                    "limit": 25,
                    "next": {
                        "href": "http://api.com/users?offset=25"
                    },
                    "last": {
                        "href": "http://api.com/users?offset=425"
                    }
                }
            }
        ```


    """
    def success_schema(data, status) do

        %{
            status: status,
            data: data,

        }
    end


    @doc """

        ## Json -Schema
        
        ```json
            {
                "timestamp": "00:07:38.774043",
                "status": 409,
                "code": 40925,
                "message": "User named xyz already exists",
                "developer_message": "user named xyz already exists. if you have a stale local cache, please expire it now",
                "more_info": "http://..."
            }
        ```

        ## Parameter
            - status (integer) The http status code
            - code (string) Statuscodes linked to documentation
            - more_info (string) URL to documentation linked to this error
    """
    def error_schema(status, code, name, message) do

        timestamp = Time.utc_now()
        %{
            timestamp: Time.to_string(timestamp),
            status: status,
            code: code, 
            message: message
        }
    end
end