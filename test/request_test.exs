defmodule ApiCommons.RequestTest do
    use ExUnit.Case

    alias ApiCommons.Request
    alias ApiCommons.Helpers.ConnUtils

    import Plug.Test


    @query_params %{
        "name" => "hero*",
        "counter" => ">5"
    }

    @body_params %{
        "name" => "test",
        "counter" => 2,
        "rating" => 2.2,
        "exists?" => false,
        "age" => <<1>>,
        "start_at" => elem(Time.new(8, 0, 0), 1),
        "end_at" => elem(Time.new(12, 0, 0), 1)
    }

    @path_params %{
        "company_id" => 12
    }


    # TODO: Test access functions?
    describe "&from/1" do

        test "Body params inserted?" do
            request = ConnUtils.create_conn(:get, "/sample/path")
            |> ConnUtils.put_body_params(@body_params) 
            |> Request.from()
        
            assert request.data[:body] && is_nil(request.data[:path]) && is_nil(request.data[:query])
        end

        test "Query params inserted?" do
            request = ConnUtils.create_conn(:get, "/sample/path")
            |> ConnUtils.put_query_params(@query_params)
            |> Request.from()

            assert request.data[:query] && is_nil(request.data[:path]) && is_nil(request.data[:body])
        end

        test "Path params inserted?" do
            request = ConnUtils.create_conn(:get, "/sample/path")
            |> ConnUtils.put_path_params(@path_params)
            |> Request.from()

            assert request.data[:path] && is_nil(request.data[:query]) && is_nil(request.data[:body])
        end
    end


    describe "&upate/2" do

        test "valid parsed parameter" do
            key = :test
            value = "new value"
            request = Request.update({:ok, key, value} ,%Request{})

            assert Map.get(request.parsed, :test) == value
        end

        test "error occured while parsing parameter" do
            key = :test
            value = "new value"
            error_code = :wrong_datatype
            request = Request.update({:error, key, value, error_code}, %Request{})
            assert Map.get(request.errors, key) == error_code
        end
    end


    describe "&params/2" do
        
        test "get all params" do
            params = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@body_params)
            |> ConnUtils.put_path_params(@path_params)
            |> ConnUtils.put_query_params(@query_params)
            |> Request.from()
            |> Request.params()

            all_keys = Map.keys(params)
            assert :body in all_keys && :path in all_keys && :query in all_keys
        end

        test "get body params" do
            params = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@body_params)
            |> ConnUtils.put_path_params(@path_params)
            |> ConnUtils.put_query_params(@query_params)
            |> Request.from()
            |> Request.params(:body)

            all_keys = Map.keys(params)
            assert "name" in all_keys
        end

        test "get path params" do
            params = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@body_params)
            |> ConnUtils.put_path_params(@path_params)
            |> ConnUtils.put_query_params(@query_params)
            |> Request.from()
            |> Request.params(:path)

            all_keys = Map.keys(params)
            assert "company_id" in all_keys
        end

        test "get query params" do
            params = ConnUtils.create_conn(:get, "/test")
            |> ConnUtils.put_body_params(@body_params)
            |> ConnUtils.put_path_params(@path_params)
            |> ConnUtils.put_query_params(@query_params)
            |> Request.from()
            |> Request.params(:query)

            all_keys = Map.keys(params)
            assert "counter" in all_keys
        end
    end

end