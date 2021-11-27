
defmodule ApiCommons.SchemaTest do
  use ExUnit.Case

  alias ApiCommons.Helpers.ConnUtils
  alias ApiCommons.Schema


  @valid_body_params %{
    "id" => 12,
    "firstName" => "john",
    "lastName" => "Doe",
  }


  defmodule SimpleMockSchema do
    use Ecto.Schema

    schema "simple_mock_schema" do
      field :firstName, :string, null: false
      field :lastName, :string
    end
  end


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




  describe "&check/3" do

    test "valid basic schema" do

      is_schema = ConnUtils.create_conn(:get, "/test")
      |> ConnUtils.put_body_params(@valid_body_params)
      |> Schema.check(SimpleMockSchema)
      IO.inspect(is_schema)
      assert false
    end

    test "invalid basic schema" do
      is_schema = ConnUtils.create_conn(:get, "/test")
      |> ConnUtils.put_body_params(@valid_body_params)
      |> Schema.check(SimpleMockSchema)

      IO.inspect(is_schema)
      assert false
    end

  end

end
