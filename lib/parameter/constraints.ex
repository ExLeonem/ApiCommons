defmodule ApiCommons.Parameter.Constraint do
    
    alias ApiCommons.Parameter


    @constraint_keys [
        :min, :max, :is, :count, # String checks
        :format, :inclusion, :exclusion, # String 
        :less_than, :less_or_equal_to, :greater_than, :greater_or_equal_to, :equal_to   
    ]

    @doc """
    Validate constraints for a given parameter.

    ## Parameter
        - param: `Parameter` struct encapsulating information

    Returns: `%Parameter{...}`
    """
    def validate(param = %Parameter{value: value, opts: opts}) do
        constraints = Keyword.take(opts, [:min, :max, :format, :exclusion, :inclusion, ])

    end


    def min(param) do
        
    end


    @doc """
    Check if value of given parameter is in a given range.
^
    ## Parameter
        - param: Parameter struct encapsulating all information 

    Returns: `%Parameter{...}`
    """
    def in_range(param = %Parameter{valid?: false}), do: param
    def in_range(param = %Parameter{name: name, value: value, type: type, opts: opts}) do
        min = opts[:min]
        max = opts[:max]

        in_min_range = !min || (min && min <= _range_metric(value, type))
        in_max_range = !max || (max && max >= _range_metric(value, type))
        case in_min_range && in_max_range do
            true -> param
            false ->
                %{param | valid?: false, error: :range_error}
        end
    end


    @doc """
    Turn value into a range comparable value. 

    ## Parameter
        - value: Term representing the parameter value
        - type: One of possible types 

    Returns: integer

    ## Examples

    iex> _range_metric("hey", :string)
    iex> 3

    iex> range_metric("helloworld", :string)
    iex> 8
    """
    defp _range_metric(value, :string), do: String.length(value)
    defp _range_metric(value, type) when type in [:integer, :float], do: value
    defp _range_metric(value, _) do
        # Throw error because, can't check value of given type for range
    end

end