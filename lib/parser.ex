defmodule ApiCommons.Parser do

    @moduledoc """
        
    """
    @callback parse(content :: term) :: term


    @doc """
    Dispatch on parser implementation.

    ## Parameters
        - implementation: Parser implementation to be used
        - data: Any data to be passed to the parser
    """
    def parse!(implementation, content) do
        case implementation.parse(content) do
            {:ok, data} -> data
            {:error, error} -> raise ArgumentError, "parsing error: #{error}"
        end
    end
end