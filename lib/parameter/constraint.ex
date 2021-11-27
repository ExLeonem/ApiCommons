defmodule ApiCommons.Parameter.Constraint do

    alias ApiCommons.Parameter

    @moduledoc """
    Check parameter for specific characterstics.

    ## TODO:
    - [ ] Add functions for :count (String size and length)
    - [ ] Add functions for :format, :inclusion, :exclusion
    """

    @any_field_constraints [:required?]
    @string_constraints [:min, :max, :is, :format, :inclusion, :exclusion]
    @num_constraints [:less_than, :less_or_equal_to, :greater_than, :greater_or_equal_to, :equal_to]
    # @time_constraints [:before, :after]


    @doc """
    Validate constraints for a given parameter.

    ## Parameter
    - `value`: The value for which to check constraints
    - `type`: The type of given value
    - `opts`: Additional options

    Returns: {:ok, value} | {:error, error_code}
    """
    @spec validate(atom(), any(), atom(), map()) :: {:ok, any()} | {:error, atom()}
    def validate(name, value, type, opts) when type == :string do
        _validate(name, value, opts, @any_field_constraints ++ @string_constraints)
    end

    def validate(name, value, type, opts) when type in [:integer, :float, :decimal] do
        _validate(name, value, opts, @any_field_constraints ++ @num_constraints)
    end

    # There are no constraint options for given type
    def validate(name, value, type, opts) do
        {:ok, value}
    end

    defp _validate(name, value, opts, constraint_keys) do
        constraints = Map.take(opts, constraint_keys) |> Map.to_list()
        result = iter(constraints, value)

        # Error validating the constraints
        case result do
            {:ok, value} -> {:ok, value}
            {:error, code} -> {:error, code}
        end
    end


    # Iterate over constraints
    defp iter(constraints, value)
    defp iter([], param_value), do: {:ok, param_value}
    defp iter([{const_fn_name, value} | tail], param_value) do

        result = apply(__MODULE__, const_fn_name, [param_value, value])
        case result do
            {:ok, value} -> iter(tail, param_value)
            {:error, msg} -> {:error, msg}
        end
    end


    @doc """
    Check whether string is at least bigger than the given limit.

    ## Parameter
    - `value`: `String` value to perform the constraint check on.
    - `size`: `Integer` value representing an lower limit.

    Returns: {:error, error_code} | {:ok, value}
    """
    @spec min(String.t(), integer()) :: {:ok, String.t()} | {:error, atom()}
    def min(value, size) when is_nil(value), do: {:ok, value}
    def min(value, size), do: _min(String.length(value) > size, value)
    defp _min(false, _value), do: {:error, :min_char_error}
    defp _min(true, value), do: {:ok, value}


    @spec max(binary, any) :: {:error, :max_char_error} | {:ok, binary}
    @doc """
    Check whether string length is smaller than given value.

    ## Parameter
    - `value`: `String` value to perform the constraint check on.
    - `size`: `Integer` value representing an upper limit.

    Returns: {:error, error_code} | {:ok, value}
    """
    @spec max(String.t(), integer()) ::  {:ok, String.t()} | {:error, atom()}
    def max(value, size) when is_nil(value), do: {:ok, value}
    def max(value, size), do: _max(String.length(value) < size, value)
    defp _max(false, _value), do: {:error, :max_char_error}
    defp _max(true, value), do: {:ok, value}


    @doc """
    Check whether the length of a string is exactly the given size.

    ## Parameter
    - `value`: `String` value to perform the constraint check on.
    - `size`: `integer()` representing the wanted size.

    Returns: {:error, error_code} | {:ok, value}
    """
    @spec is(String.t(), integer()) ::  {:ok, String.t()} | {:error, atom()}
    def is(value, size) when is_nil(value), do: {:ok, value}
    def is(value, size), do: _is(String.length(value) == size, value)
    defp _is(false, _value), do: {:error, :is_char_error}
    defp _is(true, value), do: {:ok, value}


    @doc """
    Check whether given number is smaller than given limit.

    ## Parameter
    - `value`: A numerical value.
    - `limit`: `integer()` representing the hard upper limit. (<)

    Returns: {:error, error_code} | {:ok, value}
    """
    @spec less_than(float() | integer(), integer()) :: {:ok, integer()} | {:error, atom()}
    def less_than(value, limit) when is_nil(value), do: {:ok, value}
    def less_than(value, limit), do: _less_than(value < limit, value)
    defp _less_than(false, _value), do: {:error, :less_than_error}
    defp _less_than(true, value), do: {:ok, value}


    @doc """
    Check whether given number is smaller or equal to a limit.

    ## Parameters
    - `value`: A numerical value on which to perform the constraint check.
    - `limit`: `integer()` representing a soft upper limit. (<=)

    Returns: {:error, error_code} | {:ok, value}
    """
    @spec less_or_equal_to(float() | integer(), integer()) :: {:ok, integer()} | {:error, atom()}
    def less_or_equal_to(value, limit) when is_nil(value), do: {:ok, value}
    def less_or_equal_to(value, limit), do: _less_or_equal_to(value <= limit, value)
    defp _less_or_equal_to(false, _value), do: {:error, :less_or_equal_error}
    defp _less_or_equal_to(true, value), do: {:ok, value}


    @doc """
    Check whether given number is greater than a given limit.

    ## Parameters
    - `value`: A numerical value.
    - `limit`: `integer()` representing a hard lower boundry. (>)

    Returns: {:error, error_code} | {:ok, value}
    """
    @spec greater_than(float() | integer(), integer()) :: {:ok, integer()} | {:error, atom()}
    def greater_than(value, limit) when is_nil(value), do: {:ok, value}
    def greater_than(value, limit), do: _greater_than(value > limit, value)
    defp _greater_than(false, _value), do: {:error, :greater_than_error}
    defp _greater_than(true, value), do: {:ok, value}


    @doc """
    Check whether a given number is greater or equal to a given limit.
    """
    @spec greater_or_equal_to(float() | integer(), integer()) :: {:ok, integer()} | {:error, atom()}
    def greater_or_equal_to(value, limit) when is_nil(value), do: {:ok, value}
    def greater_or_equal_to(value, limit), do: _greater_or_equal_to(value >= limit, value)
    defp _greater_or_equal_to(false, _value), do: {:error, :greater_or_equal_to_error}
    defp _greater_or_equal_to(true, value), do: {:ok, value}


    @doc """
    Check wether a given number is equal to a limit.

    ## Parameters
    - `value`: A numerical value to perform the constraint check on.
    - `limit`: `integer()` representing the required value.

    Returns: {:error, error_code} | {:ok, value}
    """
    @spec equal_to(float() | integer(), integer()) :: {:ok, integer()} | {:error, atom()}
    def equal_to(value, limit) when is_nil(value), do: {:ok, value}
    def equal_to(value, limit), do: _equal_to(value == limit, value)
    defp _equal_to(false, _value), do: {:error, :equal_to_erro}
    defp _equal_to(true, value), do: {:ok, value}


    @spec in_range(ApiCommons.Parameter.t()) :: ApiCommons.Parameter.t()
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


    @doc """
    Check whether a value was passed for the required value.

    Returns: {:error, error_code} | {:ok, value}
    """
    def required?(value, true) do
        is_empty = !(is_nil(value) || value == "")
        _required?(is_empty, value)
    end
    def required?(value, _is_required?), do: _required?(true, value)

    @spec _required?(boolean, any) :: {:error, atom()} | {:ok, any()}
    def _required?(true, value), do: {:ok, value}
    def _required?(false, value), do: {:error, :required_error}


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
