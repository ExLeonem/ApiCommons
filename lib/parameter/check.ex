    defmodule ApiCommons.Parameter.Check do
        @moduledoc """
            Similar to Ecto.Changeset. Collects and holds information on valid and invalid parameters passed to the endpoint.
            Collect information on validity of endpoint parameter check ups.

            ## Struct Keys
            - valid? (boolean) Are the provided parameters are valid?
            - schema (Ecto.Schema|nil) A schema to check parameter against
            - parsed (Map) The parsed values
            - opts (List) Additional options passed down
            - errors - The errors accumulated while checking the parameters

        """

        alias ApiCommons.Parameter
        alias ApiCommons.Parameter.Path

        @doc section: :check
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
            Update check with single parameter checks.

            ## Parameter
                - check (Check)
                - param (Parameter)

            ## Returns
                - (Check)
        """
        def update(param = %Parameter{name: name, value: value, valid?: true, opts: opts}, check) do
            parsed = Path.resolve(check.parsed, name, value)
            new_opts = Path.resolve(check.opts, name, opts)
            %{check | parsed: parsed, opts: new_opts}
        end

        def update(param = %Parameter{name: name, valid?: false, error: error, opts: opts}, check) do
            errors = Path.resolve(check.errors, name, error)
            new_opts = Path.resolve(check.opts, name, opts)
            %{check | valid?: false, errors: errors, opts: new_opts}
        end


        @doc """
            Perform an update on the check struct.

            ## Parameters
                - field (atom) The field for which to perform an update
                - value (any) The value which resulted from performing checks
                - check (Check) The old check struct

            ## Returns
                - Updated check struct.
        """
        def update(field, :cast_error, check) do
            # Add field value cast failed
            current_errors = check.errors |> Map.put(field, :cast_error)
            %{check | errors: current_errors, valid?: false}
        end

        def update(field, :empty, check) do
            # Add field is empty error
            current_errors = check.errors |> Map.put(field, :empty)
            %{check | errors: current_errors, valid?: false}
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
                opts[:optional?] && empty?(value) -> check
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