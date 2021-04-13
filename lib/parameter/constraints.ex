defmodule ApiCommons.Parameter.Constraints do

    alias ApiCommons.Parameter

    @moduledoc """
    Check parameter for specific characterstics.

    ## TODO:
        - [ ] Add functions for :min, :max, :is and :count
        - [ ] Add functions for :format, :inclusion, :exclusion
        - [ ] Add functions for :less_than, :less_or_equal_to, :greater_than, :greater_or_equal_to and :equal_to
    """

    
    @string_constraints [:min, :max, :is, :format, :inclusion, :exclusion]
    @num_constraints [:less_than, :less_or_equal_to, :greater_than, :greater_or_equal_to, :equal_to]
    # @time_constraints [:before, :after]

    
    @doc """
    Validate constraints for a given parameter.

    ## Parameter
        - value: The value for which to check constraints
        - type: The type of given value
        - opts: Additional options

    Returns: `boolean()`
    """
    @spec validate(any(), atom(), map()) :: boolean()
    def validate(value, type, opts) when type == :string do
        constraints = Keyword.take(opts, @string_constriants) |> Map.new()
        result = iter(constraints, value, {:ok, value})
    end

    def validate(value, type, opts) when type in [:integer, :float, :decimal] do
        constraints = Keyword.take(opts, @num_constraints)
        result = iter(constraints, value, {:ok, value})
    end


    @doc """

    """
    defp iter([], _param_value, acc), do: acc
    defp iter([{const_fn_name, value}], param_value, acc) do
        result = apply(__MODULE__, const_fn_name, [value, param_value])
    end


    @doc """
    Check whether string is at least bigger than the given limit.

    ## Parameter
        - value: String value
        - size: Integer value representing an lower limit.

    Returns: `boolean()`
    """
    @spec min(String.t(), integer()) :: boolean()
    def min(value, size), do: String.length(value) > size

    @doc """
    Check whether string length is smaller than given value.

    ## Parameter
        - value: String value
        - size: Integer value representing an upper limit

    Returns: `boolean()`
    """
    @spec max(String.t(), integer()) :: boolean()
    def max(value, size), do: String.length(value) < size

    
    @doc """
    Check whether string is exactly the given size

    ## Parameter
        - value: A string value
        - size: Integer representing the wanted size

    Returns `boolean()`
    """
    @spec is(String.t(), integer()) :: boolean()
    def is(value, size), do: String.length(value) == size


    @doc """
    
    """
    @spec less_than(float() | integer(), integer()) :: boolean()
    def less_than(value, limit), do: value < limit

    @doc """
    
    """
    @spec less_or_equal_to(float() | integer(), integer()) :: boolean()
    def less_or_equal_to(value, limit), do: value <= limit

    @doc """

    """
    @spec greater_than(float() | integer(), integer()) :: boolean()
    def greater_than(value, limit), do: value > limit

    @doc """

    """
    @spec greater_or_equal_to(float() | integer(), integer()) :: boolean()
    def greater_or_equal_to(value, limit), do: value >= limit

    @doc """

    """
    @spec equal_to(float() | integer(), integer()) :: boolean()
    def equal_to(value, limit), do: value == limit


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

    
    @doc """
    Check whether or not the parameter is required for processing.

    ## Parameter
        - param: Parameter struct containing all information about a single parameter check

    Returns: `%Parameter{}`
    """
    def is_required?(param = %Parameter{valid?: false}), do: param
    def is_required?(param = %Parameter{name: name, value: value, valid?: true, opts: opts}) do
        required? = opts[:required?]
        default_value = opts[:default]
        
        if (required? && (value || default_value)) || !required? do
            %{param | value: (value || default_value)}
        else
            %{param | valid?: false, error: :required_missing}
        end
    end
end