defmodule ApiCommons.Parameter.ConstraintTest do

    use ExUnit.Case

    alias ApiCommons.Parameter
    alias ApiCommons.Parameter.Constraint


    describe "&min/2" do

        test "String fullfills constraint" do
            assert {:ok, _value} = Constraint.min("hello", 2)
        end

        test "String does not fullfill constraint" do
            assert {:error, _msg} = Constraint.min("hello", 10)
        end
    end


    describe "&max/2" do

        test "String fullfills constraint" do
            assert Constraint.max("hello", 20)
        end

        test "String does not fullfill constrain" do
            assert !Constraint.max("hello", 2)
        end
    end


    describe "&is/2" do

        test "String fullfills constraint" do
            assert Constraint.is("hello", 5)
        end

        test "String does not fullfill constraint" do
            assert !Constraint.is("hello", 6)
        end
    end


    describe "&less_than/2" do

        test "Number does fullfills constraint" do
            assert Constraint.less_than(12.99, 13)
        end

        test "Number does not fullfill constraint" do
            assert !Constraint.less_than(12, 12)
        end
    end


    describe "&less_than_or_equal/2" do

        test "Number does fullfill constaint" do
            assert Constraint.less_or_equal_to(12, 12)
        end

        test "Number does not full constraint" do
            assert !Constraint.less_or_equal_to(12.2, 12)
        end
    end


    describe "&greater_than/2" do

        test "Number does fullfill constraint" do
            assert Constraint.greater_than(12, 11)
        end

        test "Number does not fullfill constraint" do
            assert !Constraint.greater_than(12, 12)
        end
    end


    describe "&greater_or_equal_to/2" do

        test "Number does fulfill constraint" do
            assert Constraint.greater_or_equal_to(12, 12)
        end

        test "Number does not fullfill constraint" do
            assert !Constraint.greater_or_equal_to(11, 12)
        end
    end


    describe "&equal_to/2" do

        test "Number does fullfill constraint" do
            assert Constraint.equal_to(12, 12)
        end

        test "Number does not fullfill constraint" do
            assert !Constraint.equal_to(12.2, 12)
        end
    end


    describe "&is_required?/1" do

        test "Valid. Required, not set but default given." do
            param = %Parameter{name: :test, value: nil, opts: %{default: 12, required?: true}}
            new_param = Constraint.is_required?(param)
            assert new_param.valid?
        end

        test "Valid. Required and value given" do
            param = %Parameter{name: :test, value: "test", opts: %{required?: true}}
            new_param = Constraint.is_required?(param)
            assert new_param.valid?
        end

        test "Invalid. Required, not set and no default value given" do
            param = %Parameter{name: :test, value: nil, opts: %{required?: true}}
            new_param = Constraint.is_required?(param)
            assert !new_param.valid?
        end

        test "Invalid. Required, no (default) value given." do
            param = %Parameter{name: :test, value: nil, opts: %{required?: true}}
            new_param = Constraint.is_required?(param)
            assert !new_param.valid?
        end
    end
end
