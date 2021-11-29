
defmodule ApiCommons.SchemaTest do
  use ExUnit.Case

  alias ApiCommons.Helpers.ConnUtils
  alias ApiCommons.Schema


  @valid_body_params %{
    "id" => "12",
    "firstName" => "john",
    "lastName" => "Doe",
  }


  defmodule SimpleMockSchema do
    use Ecto.Schema
    import Ecto.Changeset
    alias ApiCommons.Request
    alias ApiCommons.Schema

    schema "simple_mock_schema" do
      field :firstName, :string, null: false
      field :lastName, :string
    end


    def request_changeset(%Schema{data: data, errors: errors} = schema, request) do

      result = %SimpleMockSchema{}
      |> changeset(data)
      if result.valid? do
        %{schema | data: result.changes}
      else
        %{schema | errors: result.errors, valid?: false}
      end
    end

    def changeset(simple_mock, params \\ %{}) do
      simple_mock
      |> cast(params, [:firstName, :lastName])
      |> validate_required([:firstName, :lastName])
    end
  end


  defmodule TestSchema do
    """
    Mock Schema
    """

    use Ecto.Schema
    import Ecto.Changeset
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


    def create(%Schema{} = schema, request) do
      schema
    end


    def changeset(test, params \\ %{}) do
      test
      |> cast(params, [:name, :counter, :rating])
      |> validate_required([:name, :counter, :rating, :test_assoc])
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


  describe "&parse/3 simple schema ::" do

    test "valid basic schema" do
      request = ConnUtils.create_conn(:get, "/test")
      |> ConnUtils.put_body_params(@valid_body_params)
      |> Schema.parse(SimpleMockSchema)

      assert request.valid?
    end


    test "invalid basic schema with changeset validation" do
      request = ConnUtils.create_conn(:get, "/test")
      |> ConnUtils.put_body_params(%{"firstName" => "John"})
      |> Schema.parse(SimpleMockSchema, validate: &SimpleMockSchema.request_changeset/2)

      assert !request.valid?
    end
  end

  describe "&parse/3 schema with associations ::" do

    test "valid" do
      request = ConnUtils.create_conn(:get, "/test")
      |> ConnUtils.put_body_params(@valid_body_params)
      |> Schema.parse(TestSchema, validate: &TestSchema.create/2)

      IO.inspect(request)

      assert false
    end

  end

end
