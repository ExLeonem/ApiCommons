# ApiCommons

[![Coverage Status](https://coveralls.io/repos/github/ExLeonem/ApiCommons/badge.svg?branch=master)](https://coveralls.io/github/ExLeonem/ApiCommons?branch=master)
[![Build Status](https://travis-ci.com/ExLeonem/ApiCommons.svg?branch=master)](https://travis-ci.com/ExLeonem/ApiCommons)

<!-- Common operations for fast REST API development and documentation. -->


Parse received parameters against ecto schemas or manual parameter definitions.
Automatically generate error responses from errors occured while parsing.


[Mongoose-rest-api](https://www.npmjs.com/package/mongoose-rest-api)

<!-- Transform your ecto schemes into  -->
<!-- even though there are reccurant things that need to be done.
This library is an attempt to increase the speed in which REST APIs can be developed. -->


## Index 
1. [Roadmap](#Roadmap)
2. [Installation](#Installation)
3. [Dependencies](#Dependencies)
4. [Examples](#Examples)
  1. [Parameter check](#Parameter-check)
5. [Contribution](#Contribution)


## Roadmap
- [ ] Functions to check parameters manually received at endpoint
- [ ] Function to check received parameters against ecto.schema
- [ ] Auto-Generation of error responses

- [ ] Auto generation of endpoints via DSL/macro usage
  - [ ] Common operations create, index, show, delete, update
  - [ ] Auto generate view functions

- [ ] Auto-Generate OpenAPI spec and documentation (from DSL/Function definitions (Compile time inspection of functions without macro?))
- [ ] Auto-Generate HTML API Documentation

- [ ] Map Plug.Conn specific errors to REST error responses (405, ...)
- [ ] Optionally generate [Hateoas](#HATEOAS) links


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


## Parameter check


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


```elixir

defmodule AppWeb.CommentController do
  use AppWeb, :controller

  alias AppRepo.Comment
  alias ApiCommons.Parameter

  def create(conn, params) do
    param_checks = params
    |> Parameter.like_json(Comment)

    # Render either error view or the entity
    if param_checks.valid? do
      render("comment.json", params: param_checks.parsed)
    else
      render("error.json", errors: param_checks.errors)
    end
  end
end
```

# HATEOAS
  - [JSON HAL](https://tools.ietf.org/html/draft-kelly-json-hal-08)
  - [Collections + JSON](http://amundsen.com/media-types/collection/format/)
  - [Verbose](https://verbose.readthedocs.io/en/latest/)
  - [Siren](https://github.com/kevinswiber/siren)
  - [JSON:API](https://jsonapi.org/)


## Contribution

