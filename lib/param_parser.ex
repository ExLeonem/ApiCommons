defmodule ApiCommons.ParamParser do

    @callback parse(params :: term, ecto_schema :: term, opts :: map()) :: Plug.Conn.t()
    
end