defmodule ApiCommons.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :api_commons,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "ApiCommons",
      docs: [
        main: "ApiCommons",
        extras: ["README.md"],
        groups_for_modules: groups_for_modules(),
        source_ref: "v#{@version}",
        source_url: "https://github.com/ExLeonem/ApiCommons",
        # nest_modules_by_prefix: [
        #   ApiCommons.Parameter
        # ]
        # groups_for_functions: [
        #   Parameter: & &1[:section] in [:macro, :check, :path, :resolve, :parameter]
        # ]
      ]
    ]
  end

  def compiler_paths(:test), do: ["test/helpers"] ++ compiler_paths(:prod)
  def compiler_paths(_), do: ["lib"]
  

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}

      {:inch_ex, only: :docs},
      {:ecto_sql, "~> 3.4", only: :test},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:plug_cowboy, "~> 2.0", only: [:dev, :test]}
    ]
  end



  defp groups_for_modules() do
    
    [
      "Parameter": [
        ApiCommons.Parameter.Resolve,
        ApiCommons.Parameter.Check,
        ApiCommons.Parameter.Path,
        ApiCommons.Parameter.Resolve,
        ApiCommons.Parameter.Macro,
        ApiCommons.Parameter.Constraint
      ],
      "Parser": [
        ApiCommons.Parser.Schema
      ],
      "Error": [
        ApiCommons.Error.NoSchemaError,
        ApiCommons.Error.NotAFunction,
        ApiCommons.Error.UnAuthorized
      ]
    ]
  end
end
