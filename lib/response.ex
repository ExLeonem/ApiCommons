defmodule ApiCommons.Response do
    
    @moduledoc """
        Generate Endpoint responses
    """

    def to_json(data, status, opts) do
        
    end


    @doc """
        Load a response template to be filled.

        ## Parameter
            - path (string) The path to the eex template

        ## Returns
            - 
    """
    def load_template() do

    end

    
    def errors(errors, msg) do

    end


    @doc """

    
        ## Parameter
            - schema (Ecto.Schema)
            - params (map)
            - opts (map)

        ## Returns
            - 
    """
    def to_json(schema, params, opts) do
        
    end


    @doc """

        ## Parameter
            - schema (Ecto.Schema)
            - search_keys (Keyword)
            - opts (Map)

        ### Options
            - status (int) The status code to return

        ## Returns
            - search_keys (list)
            - primary_key (list)
    """
    defp outter_template(data, status_code) do
        %{
            status: 200 || status_code,
            data: data
        }
    end


    @doc """

    """
    defp default_error(opts) do
        %{

        }
    end
end