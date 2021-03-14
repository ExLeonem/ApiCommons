defmodule ApiCommons.Endpoint do
    
    @moduledoc """
        Defining REST API endpoints.
    """


    @doc """
        Auto-generate endpoints using the given resource.

        Defines the ressource to use 

        ## Parameters
            - ecto_schema (Ecto.Schema) A schema to use for 
            - params (Map)
        
        ### Params
            - depth (integer) To which depth to resolve/preload the associations
            - exclude (Map) A map %{comment: :user_id, article: [:last_upate, :text_length]} indicating which fields to skip for which schema
            - 


        ## Examples

        iex>
    """
    defmacro resource(ecto_schema, params \\ %{}) do

    end

    


    @doc """
        Define a parameter for a specific restful operation. 
        Autogenerates error messages for invalid paramater types or missing parameters.

        TODO: 

        ### Parameters
            - name (atom) The name of the parameter
            - d_type (atom) The datatype of parameter
            - params (Map) Additional parameters to be passed

        ### Params
            - optional (boolean) Indicates an optional paramater, defaults to: false
            - position (:query|:path) Indicates wether a query parameter or path parameter
            - type (:atom) The datatype of the parameter defaults to string
            - surpress_errors (booleaw) Wether or not to surpress errors fo given parameter
        
        
        ## Examples

        iex> ApiCommons.Endpoint.parameter(:title, optional: false)
    """
    defmacro param(name, d_type, params \\ %{}) do

    end


    
    # ------------------
    # Endpoint generation macros
    # ----------------------------------

    @doc """
        Generate an endpoint to request collections of ressources.
    """
    defmacro index() do
        # BODY PARAMETERS can be found in conn.body_params
        # QUERY PARAMETERS can be foun din conn.query_params
    end


    @doc """
        Generate an endpoint to cereate new ressources.
    """
    defmacro create() do
        # BODY PARAMETERS can be found in conn.body_params
        # QUERY PARAMETERS can be foun din conn.query_params
    end


    @doc """
        Generate endpoint to request information for a single resource.
    """
    defmacro show() do
        # BODY PARAMETERS can be found in conn.body_params
        # QUERY PARAMETERS can be foun din conn.query_params
    end


    @doc """
        Generate endpoint to delete a specific resource.
    """
    defmacro delete() do
        # BODY PARAMETERS can be found in conn.body_params
        # QUERY PARAMETERS can be foun din conn.query_params
    end


    @doc """
        Generate endpoint to update a resource.
    """
    defmacro update() do
        # BODY PARAMETERS can be found in conn.body_params
        # QUERY PARAMETERS can be foun din conn.query_params
    end
end