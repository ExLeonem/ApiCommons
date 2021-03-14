defmodule ApiCommons.Endpoint.Parameter do

    @moduledoc """
        Handle parameters in path & body. Provide checks for availability and values.
    """

    alias ApiCommons.Endpoint.Utils
    alias ApiCommons.Endpoint.Parameter.Check
    alias ApiCommons.Schema.Field

    @check_defaults %{position: :path, required?: true, default: nil, type: nil}


    @doc """
        Merge parameters from Plug.Conn and parameters received at endpoint.
        Puts the merged parameter into a map.

        ## Parameter
            - conn (Plug.Conn) 
            - params (Map)

        ## Returns
            - Map containing all parameters %{path: [], query: [], body: []}

        ## Examples
    """
    def merge(conn, params) do
        # BODY PARAMETERS can be found in conn.body_params
        # QUERY PARAMETERS can be foun din conn.query_params

        body_params = conn.body_params
        query_params = conn.query_params
        
        %{
            body: body_params,
            query: query_params
        }
    end
    

    @doc """
        Perform checkups of path parameters.

        ## Parameter
            - received (Map) Parameters received at endpoint
            - param_name (atom) The name of the parameter to check
            - opts (Map) Additional options

        ## Opts
            - position (atom) 
            - required? (boolean)
            - default (any)
            - type (any)
            - error (function)

        ## Examples
    """
    def path(received, param_name, opts) do

    end

    def path(received, param_name, required?, opts) do

    end


    @doc """
        Perform query parameter checkups.
    """
    def query(received, param_name, opts) do
    
    end


    @doc """
        Check the received parameters against an Ecto.Schema.
        All fields of the schema by default are required, optional fields need to be marked.
        
        TODO: 
            - Take required?/optional from the schema definition?
            - [References for development](https://github.com/elixir-ecto/ecto/blob/master/lib/ecto/schema.ex)

        ## Parameter

        ## Opts
            - position (atom) One of [:body, :path, :query], indicating where to take the parameter from
            - exclude (list(atom)) A list of parameter names as atoms to exclude
            - optional (list(atom)) A list of parameter names as atoms to mark as optional
            - preload (list(Ecto.Schema)) A list of Ecto.Schemas for preloads
            - depth (integer) The maximum depth to which to resolve associations
            - 

        ## Examples
    """
    def like_schema(received, ecto_schema, opts) do

        # Parameters after processing
        parsed_params = %Check{data: received, schema: ecto_schema, opts: opts}
        |> resolve_fields()
        |> resolve_assoc()
    end


    @doc """
        Resolve fields of a schema
    """
    defp resolve_fields(checks = %Check{data: received, schema: ecto_schema, opts: opts}) do

        to_exclude = opts[:exclude]
        is_optional = opts[:optional]

        # Collect parse regular fields of schema
        field_names = ecto_schema.__schema__(:fields)
        for field <- field_names do

            cond do
                Utils.includes?(to_exclude, field) -> nil
                Utils.includes?(is_optional, field) -> 
                    # Optional field
                    nil
                true -> 
                    field_type = ecto_schema.__schema__(:type, field)
                    value = received[field]
                    |> Utils.cast(field_type)

                    checks = Check.update(field, value)
            end
        end

        checks
    end


    @doc """
        Resolve an assocation to be included into a
    """
    defp resolve_assoc(checks = %Check{data: received, schema: ecto_schema, opts: opts}) do

        preloads = opts[:preload]
        to_exclude = opts[:exclude]
        is_optional = opts[:optional]
    
        # Collect information from associated
        assocs = ecto_schema.__schema__(:associations)
        for preload <- preloads do

            if Utils.includes?(assocs, preload) do
                
            end
        end 
    end



    @doc """
        Check wether or not the given parameter is provided as
        in the plug connection. 

        ## Parameter
            - conn (Plug.Conn) Provides information about the connection
            - parameter_name (atom) The parameter name to be checked
            - opts (Map) Additional parameters provided to direct 


        ### Options:
            - position (atom) One value of [:path, :query, :body], indicates the position of the parameter. Defaults to (:path)
            - required? (boolean) Wether or not the parameter to check is required. Defaults to (:false)
            - default (any()) The default value for given parameter, will only be applied if no value is provided for an optional parameter.
            - type (any()) The parameter type used to check. 
            - error (fn()) A function that takes an atom of type [:type, :length]

        ## Examples
    """
    def check(conn, parameter_name, opts) do
        # BODY PARAMETERS can be found in conn.body_params
        # QUERY PARAMETERS can be foun din conn.query_params


        # Is conn a Plug.Conn or a Parameter.
    end

    def check(conn, paramter_name, type \\ :required, opts) do

    end

    # def check(conn, parameter_name, type \\ :required, position \\ :path, params) do

    # end


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