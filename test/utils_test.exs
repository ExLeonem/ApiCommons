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
        
        test "Of :id" do
            
        end

    end

    describe "cast/2 ::" do

        test "of :id, " do

        end


        test "of " do

        end

    end
end