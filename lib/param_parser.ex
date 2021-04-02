defmodule ApiCommons.ParamParser do

    @callback parse(params :: term, param_definition :: term, opts :: map()) :: term
end