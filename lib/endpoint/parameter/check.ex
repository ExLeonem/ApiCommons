    defmodule ApiCommons.Endpoint.Parameter.Check do
        @moduledoc """
            Similar to Ecto.Changeset. Collects information on valid and invalid parameters passed to the endpoint.
            Collect information on validity of endpoint parameter check ups.

            - valid? - Are the provided parameters are valid?
            - action - The next action to be performed
            - errors - The errors accumulated while checking the parameters
        """

        @doc """
            Save checks on parameters
        """
        defstruct [:data, :schema,  parsed: %{}, valid?: true, errors: %{}, opts: []]


        @typedoc """
            
        """
        @type t() :: %__MODULE__{
            valid?: boolean(),
            parsed: map(),
            data: map(),
            errors: map()
        }


        @doc """
            Update the parameter check
        """
        def update(field, :cast_error, check) do
            # Add field value cast failed
            current_errors = check.errors |> Map.put(field, :cast_error)
            %{check | errors: current_errors, valid?: false}
        end

        def update(field, :empty, check) do
            # Add field is empty error
            IO.puts("Field #{field} is empty")
            current_errors = check.errors |> Map.put(field, :empty)
            %{check | errors: current_errors}
        end

        def update(field, value, check) do
            parsed = check.parsed |> Map.put(field, value)
            %{check | parsed: parsed}
        end


         @doc """
            Update the parameter checks struct.
        """
        def update(field, value, check, opts \\ []) do
            cond do
                opts[:optional?] && empty?(value) ->
                    IO.puts("Field: #{field} is optional")
                    check
                true -> update(field, value, check)
            end
        end


        @doc """
            Check whether given value is empty or not.

            ## Parameter:
                - value (any) The value to check

            ## Returns:
                - true | false whether the value is one of multiple empty values.
        """
        defp empty?(value) when value in [[], %{}, nil], do: true
        defp empty?(_value), do: false
    end