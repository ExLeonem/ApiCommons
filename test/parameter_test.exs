defmodule ApiCommons.ParameterTest do
    use ExUnit.Case

    alias ApiCommons.Parameter

    @params_split %{
        path: {

        },
        query: {

        },
        body: {

        }
    }

    @valid %{
        name: "test",
        counter: 2,
        rating: 2.2,
        exists?: false,
        image: <<1>>,
        start_at: elem(Time.new(8, 0, 0), 1),
        end_at: elem(Time.new(12, 0, 0), 1)
    }


    # Schema for test purposes
    defmodule TestSchema do
        use Ecto.Schema
        
        alias ApiCommons.ParameterTest.TestAssoc
        

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

        use Ecto.Schema

        schema "test_assoc" do
            field :content, :string
            field :counter, :integer
        end
    end


    describe "like_schema/3 ::" do
        
        test "Invalid parameters, missing keys" do
            values = Map.drop(@valid, [:name])
            parameters = Parameter.like_schema(values, TestSchema)
            refute parameters.valid?
        end


        test "Missing associations" do
            
        end
    end


    describe "check/3::" do

        test "valid single parameter check, all defaults" do
            params = %{name: "Max Mustermann"}
            checked = Parameter.check(params, :name, type: :string, default: "")
            assert checked.valid?
        end

        test "valid, nested call" do
            params = %{info: %{name: "John Doe", description: "Lorem ipsum, ..."}}
            checked = Parameter.check(params, [:info, :name], type: :string)
            IO.inspect(checked)
            assert checked.valid?
        end

        test "invalid type of parameter" do
            params = %{name: "hey"}
            checked = Parameter.check(params, :name, type: :integer, min: 5)
            assert !checked.valid? && checked.errors[:name] == :cast_error
        end

        test "invalid nested call" do
            params = %{info: %{name: "John Doe", description: "Lorem ipsum, ..."}}
            checked = Parameter.check(params, [:info, :more], type: :integer)
            IO.inspect(checked)
            assert checked.valid?
        end
    end


    describe "check/3 range" do

        test "valid min range" do
            params = %{name: "John", age: 12}
            checked = Parameter.check(params, :name, type: :string, min: 4)
            assert checked.valid?
        end

        test "invalid min range" do
            params = %{name: "John", age: 12}
            checked = Parameter.check(params, :name, type: :name, min: 5)
            assert !checked.valid? && checked.errors[:name] == :range_error
        end

        test "valid max range" do
            params = %{name: "John Doe", age: 12}
            checked = Parameter.check(params, :name, type: :string, max: 12)
            assert checked.valid?
        end

        test "invalid max range" do
            params = %{name: "John Doe", age: 12}
            checked = Parameter.check(params, :name, type: :string, max: 5)
            assert !checked.valid? && checked.errors[:name] == :range_error
        end

        test "valid range" do
            params = %{name: "John Doe", age: 12}
            checked = Parameter.check(params, :name, type: :string, min: 4, max: 8)
            assert checked.valid?
        end

        test "invalid range" do
            params = %{name: "John Doe", age: 12}
            checked = Parameter.check(params, :name, type: :string, min: 4, max: 5)
            assert !checked.valid? && checked.errors[:name] == :range_error
        end
    end
end