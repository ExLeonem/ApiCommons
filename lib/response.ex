defmodule ApiCommons.Response do
    
    alias ApiCommons.Request

    @moduledoc """

    """


    @doc """

    """
    defmacro __using__(opts) do
        
        quote do
            
            def single(data, opts \\ []) do
                __MODULE__.render_one(data, __MODULE__, "single.json")
            end

            def multi(data, opts \\ []) do
                __MODULE__.render_many(data, __MODULE__, "mutli.json")
            end
        end        
    end




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

        %{
            status: 
        }
    end



    def schema(request = %Request{}) do
        
    end


    def template(request = %Request{}) do
        
    end

end