defmodule ApiCommons.Endpoint.Parameter do

        @moduledoc """
            Handle parameters in path & body. Provide checks for availability and values.
        """

    @check_defaults %{position: :path, required?: true, default: nil, type: nil, }

    @doc """
        Check wether or not the given parameter is provided as
        in the plug connection. 

        ## Parameter
            - conn (Plug.Conn) Provides information about the connection
            - parameter_name (atom) The parameter name to be checked
            - params (Map) Additional parameters provided to direct 


        ### Params:
            - position (atom) One value of [:path, :query, :body], indicates the position of the parameter. Defaults to (:path)
            - required? (boolean) Wether or not the parameter to check is required. Defaults to (:false)
            - default (any()) The default value for given parameter, will only be applied if no value is provided for an optional parameter.
            - type (any()) The parameter type used to check. 
            - error (fn()) A function that takes an atom of type [:type, :length]

        ## Examples
    """

    def check(conn, parameter_name, params) do
        # BODY PARAMETERS can be found in conn.body_params
        # QUERY PARAMETERS can be foun din conn.query_params


        # Is conn a Plug.Conn or a Parameter.
    end

    def check(conn, paramter_name, type \\ :required, params) do

    end

    def check(conn, parameter_name, type \\ :required, position \\ :path, params) do

    end



    defmodule Check do
        @moduledoc """
            Similar to Ecto.Changeset. Collects information on valid and invalid parameters passed to the endpoint.
            Collect information on validity of endpoint parameter check ups.

            - valid? - Are the provided parameters are valid?
            - action - The next action to be performed
            - errors - The errors accumulated while checking the parameters
        """

        defstruct [:valid?, :action, :errors]

        @typedoc """
            
        """
        @type t() :: %__MODULE__{
            valid?: boolean(),
            action: atom(),
            errors: map()
        }
    end



    defmodule ErrorParse do
        @moduledoc """
            Parse invalid parameters to output anoutput message or  
        """
    end



    defmodule Macro do

        @doc """
            Defines a parameter for an endpoint
        """
        defmacro query() do
            
        end


        @doc """
            Set optional parameters
        """
        defmacro path() do

        end


        defmacro optional() do

        end


        defmacro required() do

        end
    end
end