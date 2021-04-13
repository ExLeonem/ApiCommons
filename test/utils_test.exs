defmodule ApiCommons.Endpoint.UtilsTest do
    
    use ExUnit.Case
    alias ApiCommons.Utils

    @include_key :hello

    describe "includes?/2 ::" do
        
        test "Empty list" do
            refute Utils.includes?([], @include_key)
        end

        test "Nil for list of values" do
            refute Utils.includes?(nil, @include_key)
        end

        test "Atom for list, value not included" do
            refute Utils.includes?(:some, @include_key)
        end

        # # TODO: correct, throw error?
        # test "Invalid value" do
        #     assert Utils.includes?(1, @include_key)
        # end

        test "Atom for list, value included" do
            assert Utils.includes?(@include_key, @include_key)
        end

        test "Value not in list" do
            values = [:hey, :test, :some]
            refute Utils.includes?(values, @include_key)
        end

        test "Value in list" do
            values = [:hey, :hello, :some]
            assert Utils.includes?(values, @include_key)
        end

    end


    describe "is_type/2 ::" do

        test "valid integer" do
            result = Utils.is_type("12", :integer)
            assert result
        end

        test "invalid integer" do
            result = Utils.is_type("12A", :integer)
            assert !result
        end
    end

    describe "cast/2 ::" do

        test "valid string -> integer" do
            result = Utils.cast("12", :integer)
            assert is_integer(result)
        end

        test "invalid string -> integer" do
            result = Utils.cast("a12", :integer)
            assert !is_integer(result)
        end

        test "valid string -> float" do
            result = Utils.cast("12.2", :float)
            assert is_float(result)
        end

        test "invalid string -> float" do
            result = Utils.cast("12.2A", :float)
            assert !is_float(result)
        end

        test "valid string -> boolean" do
            result = Utils.cast("true", :boolean)
            assert is_boolean(result)
        end

        test "invalid string -> boolean" do
            result = Utils.cast("truest", :boolean)
            assert !is_boolean(result)
        end

        # TODO: Extend for more ecto types {:array, type}, {:map, _}, ... 
    end
end