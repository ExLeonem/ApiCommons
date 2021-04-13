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



    test "&method/1" do
        new_conn = conn(:get, "/")
        method = Request.method(new_conn)

        assert method == "GET"
    end

    test "&endpoint/1" do
        new_conn = conn(:get, "/test")
        path = Request.endpoint(new_conn)

        assert path == "/test"
    end

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
end