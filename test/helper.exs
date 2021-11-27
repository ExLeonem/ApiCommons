
defmodule ApiCommons.Helper do

  defmodule SimpleMockSchema do
    use Ecto.Schema

    schema "simple_mock_schema" do
      field :firstName, :string
      field :lastName, :string
    end

  end


  # Schema for test purposes
  defmodule TestSchema do
    """
    Mock Schema
    """

    use Ecto.Schema
    alias ApiCommons.SchemaTest.TestAssoc


    schema "test_schema" do
        field :name, :string
        field :counter, :integer
        field :rating, :float
        field :exists?, :boolean
        field :image, :binary

        field :start_at, :time
        field :end_at, :time_usec

        belongs_to :test_assoc, TestAssoc
    end
  end


  defmodule TestAssoc do
    """
    Mock Association
    """
    use Ecto.Schema

    schema "test_assoc" do
        field :content, :string
        field :counter, :integer
    end
  end


end
