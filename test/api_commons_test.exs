defmodule ApiCommonsTest do
  use ExUnit.Case
  doctest ApiCommons

  defmodule BaseDummySchema do
    use Ecto.Schema

    schema "base_dummy_schema" do
      field :value, :string
    end
  end

  
  describe "Test :show endpoint resource generation" do
    
    test "Valid values" do
      assert true
    end

    test "Empty values" do
      assert true
    end


    test "Neither query nor schema" do
      assert true
    end

    test "Parameter, exclude" do
      assert true
    end
  end
end
