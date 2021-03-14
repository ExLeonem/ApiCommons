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
            current_errors = check.errors |> Map.put(field, :cast_error)
            %{check | errors: current_errors, valid?: false}
        end

        def update(field, value, check) do
            check.parsed |> Map.put(field, value)
        end
    end