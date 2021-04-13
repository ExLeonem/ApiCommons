defmodule ApiCommons.ParameterTest do
    use ExUnit.Case

    alias ApiCommons.Parameter
    alias ApiCommons.Helpers.ConnUtils

    @valid_query_params %{
        "name" => "hero*",
        "counter" => ">5"
    }

    @valid_body_params %{
        "name" => "test",
        "counter" => 2,
        "rating" => 2.2,
        "exists?" => false,
        "age" => <<1>>,
        "start_at" => elem(Time.new(8, 0, 0), 1),
        "end_at" => elem(Time.new(12, 0, 0), 1)
    }



    # Schema for test purposes
    defmodule TestSchema do
        """
        Mock Schema
        """

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
        """
        Mock Association
        """
        use Ecto.Schema

        schema "test_assoc" do
            field :content, :string
            field :counter, :integer
        end
    end


    describe "&check/3 single" do

        test "Existing parameter" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@valid_body_params)
            |> Parameter.check(:name, required?: true)
            
            assert checked.valid?
        end

        test "Non-existing parameter" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@vlaid_body_params)
            |> Parameter.check(:non_existent, required?: true)

            assert checked.valid?
        end

    end



    describe "&check/3 schema" do

        
    end


    describe "&check/3 map" do


    end

    describe "&check/3 type conversion ::" do

        # test "valid string to integer" do
        #     params = %{"age" => "12"}
        #     checked = Parameter.check(params, :age, type: :integer)
        #     assert checked.valid? 
        # end

        # test "invalid string to integer" do
        #     params = %{"age" => "some"}
        #     checked = Parameter.check(params, :age, type: :integer)
        #     assert !checked.valid? && checked.errors[:age] == :cast_error
        # end

        # test "valid string to time" do
        #     params = %{"time" => "08:00:00"}
        #     checked = Parameter.check(params, :time, type: :time)
        #     assert checked.valid?
        # end

        # test "invalid string to time" do
        #     params = %{"time" => "8:00:00"}
        #     checked = Parameter.check(params, :time, type: :time)
        #     assert !checked.valid? && checked.errors[:time] == :invalid_format
        # end

        # test "valid usec" do
        #     params = %{"time" => "08:00:00"}
        #     checked = Parameter.check(params, :time, type: :time_usec)
        #     assert checked.valid?
        # end
    end


    describe "&check/3 range ::" do

        # test "valid min range" do
        #     params = %{"name" => "John", "age" => 12}
        #     checked = Parameter.check(params, :name, type: :string, min: 4)
        #     assert checked.valid?
        # end

        # test "invalid min range" do
        #     params = %{"name" => "John", "age" => 12}
        #     checked = Parameter.check(params, :name, type: :name, min: 5)
        #     assert !checked.valid? && checked.errors[:name] == :range_error
        # end

        # test "valid max range" do
        #     params = %{"name" => "John Doe", "age" => 12}
        #     checked = Parameter.check(params, :name, type: :string, max: 12)
        #     assert checked.valid?
        # end

        # test "invalid max range" do
        #     params = %{"name" => "John Doe", "age" => 12}
        #     checked = Parameter.check(params, :name, type: :string, max: 5)
        #     assert !checked.valid? && checked.errors[:name] == :range_error
        # end

        # test "valid range" do
        #     params = %{"name" => "John Doe", "age" => 12}
        #     checked = Parameter.check(params, :name, type: :string, min: 4, max: 8)
        #     assert checked.valid?
        # end

        # test "invalid range" do
        #     params = %{"name" => "John Doe", "age" => 12}
        #     checked = Parameter.check(params, :name, type: :string, min: 4, max: 5)
        #     assert !checked.valid? && checked.errors[:name] == :range_error
        # end
    end
end