defmodule ApiCommons do

  require Logger

  alias ApiCommons.Schema.Field
  alias ApiCommons.Request

  @moduledoc """
  Functions and Macros for quick REST API endpoint generation.

  A full guide to REST API's can be found [here](https://restfulapi.net/)

  """


  @doc """
  Create different utilities in file.
  Depends on the parameters passed.

  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end



  @doc """
  Validate previously parsed data using a changeset.

  Returns: Schema.t()
  """
  def act(request, action_fn) do
    action_fn.(request)
  end


  @doc """
  Generate request encapsulating
  """
  def request(conn) do

  end



  @doc """
  Perform a custom action on a given parameter.

  """
  def use(%Request{}, param_name, fn_call) do

  end



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


  # @doc """
  # Call a specific render function for encoded data in conn

  # ## Parameter
  #   - conn: Plug.Conn
  #   - template: String describe the template to render
  #   - params: The parameter to pass to the render function
  # """
  # defmacro render(conn, template, params \\ %{}) do

  #   params = params |> Map.put(:conn, conn)

  #   quote do
  #     render(conn, template, params)
  #   end
  # end


  @doc """

  ## Parameter
    - request: ApiCommons.Request a processed request.
    - opts: Keyword list of options to render for

  ## Opts
    - data: The data to parse to the template
    - template: A a code to match against rander functions in view.
  """
  defmacro render(%Request{} = request, opts \\ []) do
    # IO.inspect(__CALLER__.))

    conn = request[:conn]
    quote do
      render(unquote(conn), "400.json", [])
    end
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
