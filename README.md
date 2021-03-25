# ApiCommons

[![Coverage Status](https://coveralls.io/repos/github/ExLeonem/ApiCommons/badge.svg?branch=master)](https://coveralls.io/github/ExLeonem/ApiCommons?branch=master)
[![Build Status](https://travis-ci.com/ExLeonem/ApiCommons.svg?branch=master)](https://travis-ci.com/ExLeonem/ApiCommons)

<!-- Common operations for fast REST API development and documentation. -->

Development of a REST API is tedious. Use your ecto schemes to generate endpoints quicker.


[Mongoose-rest-api](https://www.npmjs.com/package/mongoose-rest-api)

<!-- Transform your ecto schemes into  -->
<!-- even though there are reccurant things that need to be done.
This library is an attempt to increase the speed in which REST APIs can be developed. -->


## Index 
1. [Roadmap](#Roadmap)
2. [Installation](#Installation)
3. [Dependencies](#Dependencies)
4. [Examples](#Examples)
5. [Contribution](#Contribution)


## Roadmap
- [ ] Provide functions to check parameters to endpoint
- [ ] Provide functions to construct a return value for the endpoint

- [ ] Auto generation of endpoints via DSL/macro usage
  - [ ] Common operations create, index, show, delete, update
  - [ ] Auto generate view functions

- [ ] Auto-Generate OpenAPI file from DSL usage
- [ ] Auto-Generate HTML API Documentation
- [ ] Plug to sync OpenAPI definition and DSL definitions?
- [ ] Adding option for configuration to map errors



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



## Dependencies


## Examples


| Function | Description
| --- | ---
| &check/3 | Check received parameter list for a single parameter
| &like_schema/3 | Check received parameters against ecto schema



```elixir

defmodule AppWeb.CommentController do
  use AppWeb, :controller
  alias ApiCommons.Parameter

  def create(conn, params) do
    param_checks = conn
    |> Parameter.check(:user, type: :integer, position: :body)
    |> Parameter.check(:title, position: :body)
    |> Parameter.check(:content, position: :body)
    |> Parameter.check(:response_on, type: :integer, required?: false)

    # Render either error view or the entity
    if param_checks.valid? do
      render("comment.json", params: param_checks.parsed)
    else
      render("error.json", errors: param_checks.errors)
    end
  end
end

defmodule AppWeb.CommentView do
  use AppWeb, :view
  alias ApiCommons.Response

  def render("error.json", params) do
    # Render the error
  end

  def render("comment.json", params) do
    
  end
end

```


## Contribution

