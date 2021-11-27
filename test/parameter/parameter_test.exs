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
        "end_at" => elem(Time.new(12, 0, 0), 1),
        "time" => "08:00:00"
    }


    @invalid_body_params %{
        "time" => "8:00:00"
    }



    describe "body params &check/3 single" do

        test "Existing parameter" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@valid_body_params)
            |> Parameter.check(:name, required?: true)

            assert checked.valid? && checked.parsed[:name] == "test"
        end

        test "Non-existing parameter" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@valid_body_params)
            |> Parameter.check(:non_existent, required?: true)

            assert !checked.valid?
        end
    end


    describe "body params &check/3 type conversion ::" do

        test "valid string to integer" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@valid_body_params)
            |> Parameter.check(:counter, type: :integer)
            assert checked.valid?
        end

        test "invalid string to integer" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@valid_body_params)
            |> Parameter.check(:name, type: :integer)
            assert !checked.valid? && checked.errors[:name] == :cast_error
        end

        test "valid string to time" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@valid_body_params)
            |> Parameter.check(:time, type: :time)
            assert checked.valid?
        end

        test "invalid string to time" do
            params = %{"time" => "8:00:00"}
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@invalid_body_params)
            |> Parameter.check(:time, type: :time)
            assert !checked.valid? && checked.errors[:time] == :invalid_format
        end

        test "valid usec" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@valid_body_params)
            |> Parameter.check(:time, type: :time_usec)
            assert checked.valid?
        end
    end


    describe "body params &check/3 string min constraint ::" do

        test "valid" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@valid_body_params)
            |> Parameter.check(:name, type: :string, min: 2)

            assert checked.valid?
                && checked.parsed.name == @valid_body_params["name"]
        end

        test "invalid" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@valid_body_params)
            |> Parameter.check(:name, type: :string, min: 5)
            assert !checked.valid?
        end

        test "valid on missing key" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@invalid_body_params)
            |> Parameter.check(:name, type: :string, min: 2)
            assert checked.valid? && checked.parsed.name == nil
        end
    end


    describe "&check/3 string max ::" do

        test "valid" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@valid_body_params)
            |> Parameter.check(:name, type: :string, max: 20)
            assert checked.valid?
        end

        test "invalid" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@valid_body_params)
            |> Parameter.check(:name, type: :string, max: 2)
            assert !checked.valid?
        end

        test "valid on missing value" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@invalid_body_params)
            |> Parameter.check(:name, type: :string, max: 10)
            assert checked.valid?
        end
    end


    describe "&check/3 required value ::" do

        test "invalid" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@invalid_body_params)
            |> Parameter.check(:name, type: :string, min: 2, required?: true)
            assert !checked.valid?
        end

        test "valid" do
            checked = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@valid_body_params)
            |> Parameter.check(:name, type: :string, min: 2, required?: true)
            assert checked.valid?
        end
    end
end
