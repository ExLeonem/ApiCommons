defmodule ApiCommons.Schema.FieldTest do
    use ExUnit.Case
    # doctest ApiCommons.Schema.Field

    alias ApiCommons.Schema.Field

    @field_map %{
        first: :new_first,
        second: :new_second
    }
    @skip_list Map.keys(@field_map)


    describe "Check rename operations:" do

        test "Valid, No field name mapping" do
            field_name = :some
            assert Field.rename(field_name, @field_map) == field_name
        end

        test "Valid, rename field name" do
            field_name = :first
            assert Field.rename(field_name, @field_map) == @field_map[field_name]
        end

        # test "Invalid, No atom for field name given" do
        #     field_name = "something_else"
        #     assert Field.rename(field_name, @field_map)
        # end

        test "Invalid, No map for field name mapping given" do

        end

        test "Edge, No mapping nil value" do
            
        end
    end



    describe "Skip check:" do

        test "Valid, auto-transform list and skip field" do
            assert Field.exclude?(:first, @skip_list)
        end

        test "Valid, skip current" do
            skip_values = MapSet.new(@skip_list)
            assert Field.exclude?(:first, skip_values)
        end

        test "Invalid, invalid skip values passed" do
            invalid_value = "other_value"
            refute Field.exclude?(:first, invalid_value)
        end


    end

end