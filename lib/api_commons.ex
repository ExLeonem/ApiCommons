defmodule ApiCommons do

  require Logger

  alias ApiCommons.Schema.Field
  alias ApiCommons.Request
  alias ApiCommons.Parser.{}

  @moduledoc """
  Functions and Macros for quick REST API endpoint generation.

  A full guide to REST API's can be found [here](https://restfulapi.net/)

  """


  @doc """
    Use a predefined schema as a resource
  """
  def resource(conn, ecto_schema, opts) do
    

  end


  @doc """
    Create a resource
  """
  def build(conn, build_fn) when is_function(build_fn) do
    library_data = conn.private["api_commons"]
    resource_data = Map.get(library_data, :resource)
    
    case apply(build_fn, [resource_data]) do
      {:ok, data} -> data
      {:error, changeset} -> changeset
      _ -> raise "Error in &ApiCommons.build\2. Expected return value of build_fn to be a tuple of form {:ok, data} | {:error, changeset}."
    end

  end
  def build(_conn, _build_fn), do: raise "Error calling &ApiCommons.build\2. Value passed for parameter build_fn is not a function."


  @doc """
    Query entities returns the result
    
  """
  def query() do

  end


  
  @doc """
  Macro to create an rest api endpoint for resource creation.
  """
  defmacro create() do
    
  end


  @doc """
  Macro to create an rest api endpoint for resource display.
  """
  defmacro show() do
    
  end


  @doc """
  Generate an API Endpoint to request a list of ressources.

  ## Parameter
    - schema (Ecto.Schema) The schema to be used for the endpoint generation
    - params (Map) Parameters to modify the output
  """
  defmacro index() do
    
  end


  @doc """
  Macro to delete a resource.
  """
  defmacro delete() do
    
  end


  @doc """
  Macto to update a resource
  """
  defmacro put() do
    
  end
end
