defmodule ApiCommons do
  
  @moduledoc """
    Functions and Macros for quick REST API endpoint generation.
  """

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
      - 

    Returns: Map representing the ressource
  """
  def render(type, schema, values, params \\ %{})
  def render(:index, schema, values, params) do

  end

  def render(:show, schema, values, params) do

    field_names = schema.__schema__(:fields)
    base_resource = %{}

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
