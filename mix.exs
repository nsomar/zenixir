defmodule NewTest.Mixfile do
  use Mix.Project

  def project do
    [app: :zenixir,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: Coverex.Task, coveralls: true],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpotion]]
  end

  defp description do
    """
    Elixir Zendesk API Client http://developer.zendesk.com/
    """
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:httpotion, "~> 2.1.0"},
      {:poison, "~> 1.5"},
      {:exprintf, github: "parroty/exprintf"},
      {:exvcr, "~> 0.7", only: :test},
      {:coverex, "~> 1.4.7", only: :test},
      {:inch_ex, ">= 0.0.0", only: :docs}]
  end
end
