defmodule ApiCommons.ParameterTest do
    use ExUnit.Case

    alias ApiCommons.Parameter

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


    describe "&like_schema/3 ::" do
        
        test "Invalid parameters, missing keys" do
            values = Map.drop(@valid, [:name])
            parameters = Parameter.like_schema(values, TestSchema)
            refute parameters.valid?
        end


        test "Missing associations" do
            
        end
    end


    describe "&check/3::" do

        test "valid single parameter check, all defaults" do
            params = %{name: "Max Mustermann"}
            checked = Parameter.check(params, :name, type: :string, default: "")
            assert checked.valid?
        end

        test "valid, nested call" do
            params = %{info: %{name: "John Doe", description: "Lorem ipsum, ..."}}
            checked = Parameter.check(params, [:info, :name], type: :string)
            assert checked.valid?
        end

        test "valid missing optional key" do
            params = %{name: "hey"}
            checked = Parameter.check(params, :some)
            assert checked.valid?
        end

        test "invalid missing required key" do
            params = %{name: "hey"}
            checked = Parameter.check(params, :some, required?: true)
            assert !checked.valid? && checked.errors[:some] == :required_missing
        end

        test "valid missing optional nested key" do
            params = %{info: %{name: "John Doe", description: "Lorem ipsum, ..."}}
            checked = Parameter.check(params, [:info, :more], type: :integer)
            assert checked.valid?
        end

        test "invalid missing required nested key" do
            params = %{info: %{name: "John Doe", description: "Hello world"}}
            checked = Parameter.check(params, [:info, :more], required?: true)
            assert !checked.valid?
        end

        test "option merge on valid check" do
            params = %{name: "john doe", title: "hello world"}
            checked = params
            |> Parameter.check(:name, required?: true)
            |> Parameter.check(:title, required?: true)
            assert checked.opts[:name] && checked.opts[:title]
        end

        test "option merge on invalid check" do
            params = %{name: "john doe", title: "hello world"}
            checked = params
            |> Parameter.check(:name, required?: true)
            |> Parameter.check(:title, required?: true, type: :integer)
            assert checked.opts[:name] && checked.opts[:title]
        end
    end

    describe "&check/3 type conversion ::" do

        test "valid string to integer" do
            params = %{age: "12"}
            checked = Parameter.check(params, :age, type: :integer)
            assert checked.valid? 
        end

        test "invalid string to integer" do
            params = %{age: "some"}
            checked = Parameter.check(params, :age, type: :integer)
            assert !checked.valid? && checked.errors[:age] == :cast_error
        end

        test "valid string to time" do
            params = %{time: "08:00:00"}
            checked = Parameter.check(params, :time, type: :time)
            assert checked.valid?
        end

        test "invalid string to time" do
            params = %{time: "8:00:00"}
            checked = Parameter.check(params, :time, type: :time)
            assert !checked.valid? && checked.errors[:time] == :invalid_format
        end

        test "valid usec" do
            params = %{time: "08:00:00"}
            checked = Parameter.check(params, :time, type: :time_usec)
            assert checked.valid?
        end
    end


    describe "&check/3 range ::" do

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