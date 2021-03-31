defmodule ApiCommons do
  alias ApiCommons.Schema.Field
  alias ApiCommons.Request

  @moduledoc """
    Functions and Macros for quick REST API endpoint generation.

    A full guide to REST API's can be found [here](https://restfulapi.net/)

    ## [HTTP Codes](https://restfulapi.net/http-status-codes/)
      - 1xx *Informational* - Communicates transfer protocol-level information
      - 2xx *Success* - Indicates that the clients request was accepted successfully
      - 3xx *Redirection* - Indicates that the client must take some additional action in order to complete request.
      - 4xx *Client Error* - Category of error status codes point finger at client.
      - 5xx *Server Error* - Server takes responsibility for these error status codes.


    ### 2xx

      - 200 (OK) - REST API request successfully carried out.
      - 201 (Created) - Resource was created inside a collection.
      - 202 (Accepted) - For long processes. Request accepted for processing
      - 204 (No Content) - Rest API declines to send back any status message or representation.

    ### 3xx
      
      - 301 (Moved) - REST API model has significantly been redesigned
      - 302 (Found) -
      - 303 (See Other) - 
      - 304 (Not Modified) - 
      - 307 (Temporary Redirect) - 


    ### 4xx

      - 400 (Bad Request) - Generic client-side error
      - 401 (Unauthorized) - Client tried to operate on a protected resource
      - 403 (Forbidden) - Client request formed correctly, REST Api won't honor it.
      - 404 (Not Found) - Can't map URI to a resource
      - 405 (Method Not Allowed) API responds with a 405 error to indicate 
    

  """


  @doc """
    Build a resource out of accumulated data.

    ## Parameter
      - 

  """
  def build(build_function, request, acc_key) do

  end


  @doc """
    Query entities returns the result
    
  """
  def query() do

  end


  

  @doc """

    # 
  """
  def request(conn) do

    %Request{}

  end


  def response(data, opts \\ [])
  def response(data, opts) do

      
  end


  @doc """
      Use an ecto schema as a base for generation of a
  """
  defmacro schema(ecto_schema, params \\ %{}) do

  end
  

  @doc """
    Perform renders of ecto schemas to map.

    ### Parameter
      - type (atom) The Type of render to perform
      - schema (Ecto.Schema) The ecto schema to be used for endpoint generation
      - values () Realisation of an ecto schema, containing the values.
      - params () Additional parameters to be passed

    #### params
      - paginate (integer|nil) Wether or not to paginate over the items
      - sort (map) %{desc: :field_name} or %{asc: :field_name} 
      - exclude (list[atom]) List of field name as atoms, which to skip for json generation
      - 

    Returns: Map representing the ressource
  """
  def render(type, schema, values, params \\ %{})
  def render(:index, schema, values, params) do

  end

  def render(:show, schema, values, params) do

    # TODO: use Map.from_struct()

    # Need to check wether values are valid changeset or not
    field_names = schema.__schema__(:fields)
    base_resource = %{}

    # MapSet for faster lookup
    skip_values = if params[:skip] do
      MapSet.new(params[:skip])
    end

    # For each field name perform transformation & add to ressource information
    for field_name <- field_names do

      # Skip specific field?
      if Field.exclude?(field_name, params[:skip]) do
        new_field_name = Field.rename(field_name, params[:rename])
        # TODO: Check wether resulting field is no unloaded assoc or another map

        # Map.put(base_resource, new_field_name, )
      end
    end

  end

  @doc """
    Link single schema to another
  """
  def link(schema, other_schema, name \\ nil) do
    # Item |> link(Store)
    
  end

  @doc """
    Link multiple schemas to one
  """
  def link_multi(schema, schemas, names \\ nil) do
    # Item |> link_multi([Store, ItemImage]) # Need to check for many, belongs_to, one assocs

  end


  @doc """
    Generate an API Endpoint to request a list of ressources.

    ### Parameter
      - schema (Ecto.Schema) The schema to be used for the endpoint generation
      - params (Map) Parameters to modify the output
  """
  defmacro index(schema, params \\ %{}) do

  end

  # Additional macros for create, show, delete, modify
end
