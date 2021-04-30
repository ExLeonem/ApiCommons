defmodule ApiCommons.Error do
    

    @moduledoc """

    ## Parameter parse errors

    - `:
    
    ### Examples

        [{ 
            "errorCode": "BAD_FORMAT", 
            "field": "email", 
            "originalValue": "suhas.chatekar", 
            "mesage": "{email} is not in correct format",
            "helpUrl": "/help/BAD_FORMAT#email" 
        }]


        {
            "id":      "rate_limit",
            "message": "Account reached its API rate limit.",
            "url":     "https://docs.service.com/rate-limits"
        }

    ## API Error codes
    
    ### 3xx
       - 301 (Moved) - REST API model has significantly been redesigned
       - 302 (Found) -
       - 303 (See Other) - 
       - 304 (Not Modified) - 
       - 307 (Temporary Redirect) - 
 
 
     ### 4xx
 
       - 400 (Bad Request) - Generic client-side error
       - 401 (Unauthorized) - Client tried to operate on a protected resource
       - 403 (Forbidden) - Client request formed correctly, REST Api won't honor it.
       - 404 (Not Found) - Can't map URI to a resource
       - 405 (Method Not Allowed) API responds with a 405 error to indicate 
    """

    defstruct [:code, :name, :message, url: nil, description: nil]


    def new(params) do
        struct(__MODULE__, params)
    end

    @doc """
    Transform an error 
    """
    def transform(error, opts \\ []) do
        
    end


    defmodule NotAFunction do
        
    end



    defmodule UnAuthorized do 
        @moduledoc """
            Exception raised when trying to access a route without authorization
        """

        defexception plug_status: 401, message: "No authorization to use this route", conn: nil, router: nil

        def exception(opts) do
            
        end
    end

    defmodule NoSchemaError do
        @moduledoc """
        
        """

        defexception [:message]

        def exception(value) do
            msg = "Passed value #{value} is not a Ecto.Schema."
            %NoSchemaError{message: msg}
        end
    end
end