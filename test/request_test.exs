defmodule ApiCommons.RequestTest do
    use ExUnit.Case
    use Plug.Test

    alias ApiCommons.Request


    describe "&new/1" do

        test "default" do
            test_connection = conn(:get, "/sample/path")
            assert true
        end
    end
end