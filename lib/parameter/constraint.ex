defmodule ApiCommons.Parameter.Constraint do

    alias ApiCommons.Parameter

    @moduledoc """
    Check parameter for specific characterstics.

    ## TODO:
    - [ ] Add functions for :min, :max, :is and :count
    - [ ] Add functions for :format, :inclusion, :exclusion
    - [ ] Add functions for :less_than, :less_or_equal_to, :greater_than, :greater_or_equal_to and :equal_to
    """

    @any_field_constraints [:required]
    @string_constraints [:min, :max, :is, :format, :inclusion, :exclusion]
    @num_constraints [:less_than, :less_or_equal_to, :greater_than, :greater_or_equal_to, :equal_to]
    # @time_constraints [:before, :after]


    @doc """
    Validate constraints for a given parameter.

    ## Parameter
    - `value`: The value for which to check constraints
    - `type`: The type of given value
    - `opts`: Additional options

    Returns: `boolean`
    """
    @spec validate(atom(), any(), atom(), map()) :: boolean()
    def validate(name, value, type, opts) when type == :string do
        _validate(name, value, opts, @any_field_constraints ++ @string_constraints)
    end

    def validate(name, value, type, opts) when type in [:integer, :float, :decimal] do
        _validate(name, value, opts, @any_field_constraints ++ @num_constraints)
    end

    defp _validate(name, value, opts, constraint_keys) do
        constraints = Map.take(opts, constraint_keys) |> Map.to_list()

        IO.inspect(constraints)
        IO.puts("-------")

        result = iter(constraints, value, {:ok, value})
        # Error validating the constraints
        case result do
            {:ok, value} -> {:ok, name, value}
            {:error, code} -> {:error, name, value, code}
        end
    end


    # Iterate over constraints
    defp iter(constraints, value, acc \\ {})
    defp iter([], _param_value, acc), do: acc
    defp iter([{const_fn_name, value} | tail], param_value, acc) do

        IO.puts(const_fn_name)
        result = apply(__MODULE__, const_fn_name, [value, param_value])
        IO.inspect(result)
        IO.puts("------------")

        result
    end


    @doc """
    Check whether string is at least bigger than the given limit.

    ## Parameter
    - `value`: `String` value
    - `size`: `Integer` value representing an lower limit.

    Returns: `boolean`
    """
    @spec min(String.t(), integer()) :: boolean()
    def min(value, size), do: String.length(value) > size

    @doc """
    Check whether string length is smaller than given value.

    ## Parameter
    - `value`: `String` value
    - `size`: `Integer` value representing an upper limit

    Returns: `boolean`
    """
    @spec max(String.t(), integer()) :: boolean()
    def max(value, size), do: String.length(value) < size


    @doc """
    Check whether string is exactly the given size

    ## Parameter
    - value: A string value
    - size: Integer representing the wanted size

    Returns `boolean`
    """
    @spec is(String.t(), integer()) :: boolean()
    def is(value, size), do: String.length(value) == size


    @doc """
    Check whether given number is smaller than given limit.
    Returns: `boolean`
    """
    @spec less_than(float() | integer(), integer()) :: boolean()
    def less_than(value, limit), do: value < limit

    @doc """
    Check whether given number is smaller or equal to a limit.
    """
    @spec less_or_equal_to(float() | integer(), integer()) :: boolean()
    def less_or_equal_to(value, limit), do: value <= limit

    @doc """
    Check whether given number is greater than a given limit.
    """
    @spec greater_than(float() | integer(), integer()) :: boolean()
    def greater_than(value, limit), do: value > limit

    @doc """
    Check whether a given number is greater or equal to a given limit.
    """
    @spec greater_or_equal_to(float() | integer(), integer()) :: boolean()
    def greater_or_equal_to(value, limit), do: value >= limit

    @doc """
    Check wether a given number is equal to a limit.
    """
    @spec equal_to(float() | integer(), integer()) :: boolean()
    def equal_to(value, limit), do: value == limit

    @doc """
    Check if value of given parameter is in a given range.

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



    def required?(value, true) when is_nil(value), do: {:ok, value}
    def required?(value, _is_required?), do: {:ok, value}


    @doc """
    Check whether or not the parameter is required for processing.

    ## Parameter
    - param: Parameter struct containing all information about a single parameter check

    Returns: `%Parameter{}`
    """
    @spec is_required?(Parameter.t()) :: Parameter.t()
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
