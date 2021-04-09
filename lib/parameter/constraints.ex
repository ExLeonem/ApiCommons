defmodule ApiCommons.Parameter.Constraints do
    
    alias ApiCommons.Parameter

    @moduledoc """
    Check parameter for specific characterstics.

    ## TODO:
        - [ ] Add functions for :min, :max, :is and :count
        - [ ] Add functions for :format, :inclusion, :exclusion
        - [ ] Add functions for :less_than, :less_or_equal_to, :greater_than, :greater_or_equal_to and :equal_to
    """


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


    @doc """
    Cast a parameter value to specific type.

    ## Examples

        iex> param = %Parameter{name: :test, value: "12", type: :integer}
        iex> cast(param)
        %Parameter{
            name: :test,
            value: 12,
            valid?: true,
            opts: %{}}

        iex> param = %Parameter{name: :test, value: "1k", type: :integer}
        iex> cast(param)
        %Parameter{
            name: :test,
            valuer: 12,
            valid?: false,
            errors: [:cast]}

    """
    @spec of_type(Parameter.t()) :: Parameter.t()
    def of_type(param = %Parameter{valid?: false}), do: param
    def of_type(param = %Parameter{name: name, value: value, valid?: true, opts: opts}) do
        type = opts[:type]
        casted_value = Utils.cast(value, type)

        case casted_value do
            :cast_error -> %{param | error: :cast_error, valid?: false}
            :invalid_format -> %{param | error: :invalid_format, valid?: false}
            _ -> %{param | value: casted_value}
        end
    end
end