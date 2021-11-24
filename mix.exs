defmodule ApiCommons.MixProject do
  use Mix.Project

  @version "0.1.1"

  def project do
    [
      app: :api_commons,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),

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


  defp package() do
    [
      maintainers: ["Maksim Sandybekov"],
      description: "Ease creation of REST API endpoints in phoenix.",
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/ExLeonem/ApiCommons"
      }
    ]
  end

  defp groups_for_modules() do

    [
      "Parameter": [
        ApiCommons.Parameter.Resolve,
        ApiCommons.Parameter.Check,
        ApiCommons.Parameter.Path,
        ApiCommons.Parameter.Resolve,
        ApiCommons.Parameter.Schema,
        ApiCommons.Parameter.Constraint,
      ],
      "Error": [
        ApiCommons.Error.NoSchemaError,
        ApiCommons.Error.NotAFunction,
        ApiCommons.Error.UnAuthorized
      ]
    ]
  end
end
