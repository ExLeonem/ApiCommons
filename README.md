# ApiCommons

Common operations for fast REST API development and documentation.


## Roadmap/Ideas:
  - [ ] Is it possible to get field definitions of a query object? YES -> query.select, query.
  - [ ] Use Plugs to generate complete endpoint?
  - [ ] Auto-generate openAPI spec/html
  - [ ] Create ability to dump generated documentation, server over endpoint.
  - [ ] Auto-generate view 



  ```elixir
    # Check wether parameter of a specific struct
    def takesStruct(struct = %StructTest{}) do
  ```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `api_commons` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:api_commons, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/api_commons](https://hexdocs.pm/api_commons).

