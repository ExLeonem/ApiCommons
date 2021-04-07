defmodule ApiCommons.ParamParser do

    @moduledoc """
        
    """
    

    @callback parse(params :: term, param_definition :: term, opts :: map()) :: term


    @doc """
    Dispatch on parser implementation.
    """
    def parse!(implementation, params) do
        case implementation.parse(params) do
            {:ok, data} -> data
            {:error, error} -> raise ArgumentError, "parsing error: #{error}"
        end
    end
end