defmodule ApiCommons.Template do

    alias ApiCommons.Error


    @doc """
    Generate a json error response for a single error message.

    ## Parameter

    Returns: `Map`
    """
    def error(status_code, name, message) do
        _error(status_code, name, message)
        |> add_timestamp()
    end


    @doc """
    Generate a json error response out of a list of errors.

    ## Parameter

    Returns: `Map`
    """
    def errors(errors) do
        errors = Enum.map(errors, fn error_def ->
            _error(error_def.status_code, error_def.name, error_def.message) 
        end)

        %{
            errors: errors
        }
        |> add_timestamp()
    end


    @doc """
    The base for error json response.

    Returns: `Map`
    """
    defp _error(status_code, name, message) do
        %{
            status: status_code,
            error: name,
            message: message
        }
    end


    @doc """

    """
    def default_json_errors(error_codes) do
        
    end


    # @doc """
    # Fetch pagination information. To limit the output.

    # [Pagination options](https://www.moesif.com/blog/technical/api-design/REST-API-Design-Filtering-Sorting-and-Pagination/)

    # ## Parameter
    #     - data (map) Received parameter to be processed.
    #     - defaults (Keyword) Default parameters when no pagination information was found [limit: 10, offset: 0]

    # ## Pagination options
    #     - offset (integer) The entity where to begin
    #     - limit (integer) The amount of items to return

    # ## Returns
    #     - Request struct for further processing
    # """
    # def pagination(params, defaults \\ [limit: 10, offset: 0])
    # def pagination(params, defaults) do
       
    # end

    # def pagination(params = %{} , defaults) do
    #     temp_limit = defaults[:limit]
    #     limit = if (!is_nil(temp_limit) && temp_limit > 0), do: temp_limit, else: 0

    #     temp_offset = defaults[:offset]
    #     offset = if limit > 0 && !is_nil(temp_offset) && temp_offset > 0, do: temp_offset, else: 0

    #     params
    #     |> check(:limit, position: :query, type: :integer, acc: :paginate, default: limit)
    #     |> check(:offset, position: :query, type: :integer, acc: :paginate, defaul: offset)
    # end


    @doc """
    Adds a timestamp to map

    ## Parameter
        - map: Map to which to add a timestamp field

    Returns: `Map`
    """
    defp add_timestamp(map) do
        timestamp = Time.utc_now() |> Time.to_string()
        Map.put(map, :timestamp, timestamp)
    end

end