defmodule ApiCommons.Endpoint.ParameterTest do
    use ExUnit.Case

    alias ApiCommons.Endpoint.Parameter


    # Schema for test purposes
    defmodule TestSchema do
        use Ecto.Schema
        
        alias ApiCommons.Endpoint.ParameterTest.TestAssoc
        

        schema "test_schema" do
            field :name, :string
            field :counter, :integer
            field :rating, :float
            field :exists?, :boolean
            field :image, :binary

            field :start_at, :time
            field :end_at, :time_usec

            belongs_to :comments, TestAssoc
        end

    end


    defmodule TestAssoc do

        use Ecto.Schema

        schema "test_assoc" do
            field :content, :string
            field :counter, :integer
        end
    end


    describe "like_schema/3 ::" do
        
        test "" do
            
        end
    end
end