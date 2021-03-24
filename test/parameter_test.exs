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


    describe "check/3 ::" do

        test "valid single parameter check, all defaults" do
            params = %{name: "Max Mustermann"}
            checkd = Parameter.check(params, :name, type: :string, default: "")

            IO.inspect(checkd)

            assert checkd.valid?
        end

        test "valid, nested call" do
            params = %{info: %{name: "John Doe", description: "Lorem ipsum, ..."}}
            checked = Parameter.check(params, [:info, :name], type: :string)

            assert checked.valid?
        end

        test "invalid type of parameter" do
            params = %{name: "hey"}
            checked = Parameter.check(params, :name, type: :integer) 
            assert checked.valid?
        end

        test "" do
            
        end
    end
end