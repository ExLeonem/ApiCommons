defmodule ApiCommons.Parser.Schema do
    @behaviour ApiCommons.Parser
     
    alias ApiCommons.Request
    alias ApiCommons.Parameter.Check
    alias ApiCommons.Utils
    require Logger




    @moduledoc """
    Check parameters against an ecto schema.
    """

    @doc """
    Parse received parameters at endpoint against an Ecto.Schema.


    ## Parameters
        - params: 
        - ecto_schema: Ecto.Schema identifying all fields to be used 

    ## Params
        - data: Map of parameters to be parsed
        - schema: Ecto.Schema to be used to parse the data
    """
    @imp ApiCommons.ParamParser
    def parse(data) do

        schema = data[:schema]
        

        # # Parameters after processing
        # parsed_params = %Check{data: received, schema: ecto_schema, opts: opts}
        # |> Resolve.fields()
        # |> Resolve.assocs()

        result = nil
        {:ok, result}
    end

end