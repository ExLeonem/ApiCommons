defmodule ApiCommons.Changeset do

  @defmodule """
    A changeset represents the validitity of a set of parameters.

  """

  alias __MODULE__


  defstruct [
    action: nil,
    changes: %{},
    errors: [],
    data: %{},
    valid?: false
  ]


  @doc """
  Create a new changeset

  """
  def new() do

  end




  @doc """
  Is the given Changeset
  """
  def is_valid?(%Changeset{valid?: valid} = changeset), do: valid


  @doc """
  Exctract a specific key from the changeset data.

  """
  def get(%Changeset{} = changeset, key) do

  end

end
