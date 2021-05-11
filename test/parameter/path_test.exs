defmodule ApiCommons.Parameter.PathTest do
    use ExUnit.Case
    alias ApiCommons.Parameter.Path

    @param_list %{
        outter_param: "hello world",
        nested_param: %{
            inner_test: 12,
            more_nested: %{
                most_inner: 17
            }
        }
    }

    describe "&get/2" do

        test "get outter value from nested map" do
            result = Path.get(@param_list, "outter_param")
            assert result == @param_list[:outter_param]
        end

        test "get innner value from nested map" do
            result = Path.get(@param_list, ["nested_param", "inner_test"])
            assert result == 12
        end

        test "get most inner value" do
            result = Path.get(@param_list, ["nested_param", "more_nested", "most_inner"])
            assert result == 17
        end

        test "access non-existent flat" do
            result = Path.get(@param_list, "non_existent")
            assert result == nil
        end

        test "access non-existen inner" do
            result = Path.get(@param_list, ["nested_param", "non_existent"])
            assert result == nil
        end

        test "path key is nil" do
            result = Path.get(@param_list, nil)
            assert result == nil
        end

        test "path key is empty list" do
            result = Path.get(@param_list, [])
            assert result == nil
        end
    end


    describe "&put/2" do

        test "put value under flat key" do
            key = :key
            value = :value
            updated = Path.put(%{}, key, value)

            assert Map.get(updated, key) == value
        end

        test "put value under nested key (single nesting level)" do
            key = [:first, :second]
            value = :value
            updated = Path.put(%{}, key, value)
            assert Path.get(updated, key) == value
        end

        test "put value under nested key (two nesting levels)" do
            key = [:first, :second]
            value = :value
            updated = Path.put(%{}, key, value)
            assert Path.get(updated, key) == value
        end

    end

    describe "&put/3" do

        test "put value under flat key" do
            key = :key
            value = :value
            updated = Path.put(%{}, key, value)
            
            assert Map.get(updated, key) == value
        end

        test "put value under single nesting level" do
            path = ["key", "inner"]
            value = :value
            updated = Path.put(%{}, path, value)

            assert Path.get(updated, path) == value
        end

        test "put value under second nesting level" do
            path = ["key", "inner", "second_inner"]
            value = :value
            updated = Path.put(%{}, path, value)

            assert Path.get(updated, path) == value
        end
    end
end