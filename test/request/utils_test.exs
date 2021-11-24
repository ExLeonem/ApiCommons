defmodule ApiCommons.Request.UtilsTest do
    use ExUnit.Case

    alias ApiCommons.Request.Utils
    import Plug.Test

    test "&method/1" do
        new_conn = conn(:get, "/")
        method = Utils.method(new_conn)

        assert method == "GET"
    end

    test "&endpoint/1" do
        new_conn = conn(:get, "/test")
        path = Utils.endpoint(new_conn)

        assert path == "/test"
    end

end