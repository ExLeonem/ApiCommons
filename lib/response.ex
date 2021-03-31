defmodule ApiCommons.Response do
    
    alias ApiCommons.Request

    @moduledoc """

    """


    @doc """
        Return single resource 


    """
    def single(schema, opts \\ []) do

    end


    @doc """
        Resond with multiple entities.

    """
    def multi(data, opts) do

    end

    
    @doc """
        Respond with error.

        ## Parameter
            - errors () List of errors received 
            - opts (Keyword) Additional options

        ## Returns
            - 
    """
    def error(errors, opts \\ []) do

        # %{
        #     status: 
        # }
    end

    
    def schema(request = %Request{}) do
        
    end
end